library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;
use work.IORecord.DataInp;

entity Reader is
 generic(opBase     : unsigned;
         rdAddrBits : positive;
         outBits    : positive
         );
 port (
  clk  : in std_logic;
  init : in std_logic;

  inp  : in DataInp;

  -- din : in std_logic;
  -- dshift : in boolean;
  -- op : in unsigned(opb downto 0);
  -- load : in boolean;

  copy : in std_logic;

  copyOut : out std_logic := '0';
  opOut   : out unsigned(opb-1 downto 0) := (others => '0');
  active  : out std_logic := '0'
  );
end Reader;

architecture behavioral of Reader is

 constant byteBits : positive := 8;

 type ctlFsm is (cIdle, cShift, cWrite, cUpdAdr);
 signal ctlState : ctlFsm := cIdle;

 type runFsm is (rIdle, raddr, rCopy, rData, rShift, rDone);
 signal runState : runFsm := rIdle;

 signal dataReg : unsigned (byteBits-1 downto 0);

 signal rdAddress : unsigned (rdAddrBits-1 downto 0) := (others => '0');
 signal wrAddress : unsigned (rdAddrBits-1 downto 0) := (others => '0');

 signal writeEna : std_logic := '0';
 signal opSel : std_logic;

 signal outData : std_logic_vector (byteBits-1 downto 0);

 signal data : unsigned (byteBits-1 downto 0) := (others => '0');

 signal count : integer range 0 to outBits := 0;

begin

 shiftProc : entity work.ShiftOpSel
  generic map(opVal => opBase + F_Ld_Ctrl_Data,
              n =>     byteBits)
  port map(
   clk => clk,

   inp => inp,
   -- din => din,
   -- op => op,
   -- shift => dshift,
   sel => opSel,
   data => dataReg
   );

 memProc : entity work.rdMem
  port map
  (
   clock     => clk,
   data      => std_logic_vector(dataReg),
   rdaddress => std_logic_vector(rdAddress),
   wraddress => std_logic_vector(wrAddress),
   wren      => writeEna,
   q         => outData
   );

 Proc : process(clk)
  variable  readSel : std_logic;
 begin
  if (rising_edge(clk)) then
   if (init = '1') then
    ctlState <= cIdle;
    runState <= rIdle;
    writeEna <= '0';
   else
    if (opSel = '1') then
     case ctlState is
      when cIdle =>                      --idle
       if ((opSel = '1') and (copy = '1')) then
        wrAddress <= (others => '0');
        count <= 7;
        ctlState <= cShift;
       end if;

      when cShift =>                     --shift data in
       if ((opSel = '0') or (inp.load = '1')) then
        ctlState <= cIdle;
       elsif (inp.shift = '1') then
        if (count /= 0) then
         count <= count - 1;
        else
         writeEna <= '1';
         count <= 7;
         ctlState <= cWrite;
        end if;
       end if;

      when CWrite =>                    --write to memory
       writeEna <= '0';
       ctlState <= cUpdAdr;

      when cUpdAdr =>                   --update address
       wrAddress <= wrAddress + 1;
       ctlState <= cShift;

      when others => null;
     end case;
    end if;

    if (inp.op = opBase + F_Read) then
     readSel := '1';
    else
     readSel := '0';
    end if;

    case runState is
     when rIdle =>                      --idle
      if (readSel = '1') then
       active <= '1';
       rdAddress <= (others => '0');
       runState <= raddr;
      end if;

     when rAddr =>
      opOut <= unsigned(outData);
      count <= outBits-1;
      runState <= rCopy;

     when rCopy =>
      copyOut <= '1';
      runState <= rData;
      
     when rData =>
      copyOut <= '0';
      rdAddress <= rdAddress + 1;
      runState <= rShift;

     when rShift =>
      if (inp.shift = '1') then
       if (count /= 0) then
        count <= count - 1;
       else
        if (rdAddress < wrAddress) then
         runState <= rAddr;
        else
         opOut <= (others => '0');
         runState <= rDone;
        end if;
       end if;
      end if;

     when rDone =>
      active <= '0';
      if (readSel = '0') then
       runState <= rIdle;
      end if;

     when others => null;
    end case;
    
   end if;
  end if;
 end process Proc;

end behavioral;
