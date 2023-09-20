library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.regdef.all;

entity QuadDro is
 generic (opBase : unsigned;
          opBits : positive;
          droBits : positive;
          outBits : positive);
 port (
  clk : in std_logic;
  din : in std_logic;
  dshift : in boolean;
  op : in unsigned(opBits - 1 downto 0);
  load : in boolean;
  dshiftR : in boolean;
  opR : in unsigned(opBits-1 downto 0);
  copyR : in boolean;
  quad : in std_logic_vector(1 downto 0);
  dirInvert : in std_logic;
  endCheck : in std_logic;
  decelDisable : out boolean := false;
  done : out boolean := false;
  dout : out std_logic := '0'
  );
end QuadDro;

architecture Behavioral of QuadDro is

 component ShiftOp is
  generic(opVal : unsigned;
          opBits : positive;
          n : positive);
  port(
   clk : in std_logic;
   din : in std_logic;
   op : in unsigned (opBits-1 downto 0);
   shift : in boolean;
   data : inout unsigned (n-1 downto 0)
   );
 end Component;

 component ShiftOutNS is
  generic(opVal : unsigned;
          opBits : positive;
          n : positive;
          outBits : positive);
  port (
   clk : in std_logic;
   dshift : in boolean;
   op : in unsigned (opBits-1 downto 0);
   copy : in boolean;
   data : in unsigned(n-1 downto 0);
   dout : out std_logic
   );
 end Component;

 alias a : std_logic is quad(0);
 alias b : std_logic is quad(1);

 signal quadState : std_logic_vector(3 downto 0) := (others => '0');
 signal dir : std_logic := '0';

 signal ch : std_logic := '0';
 signal update : std_logic := '0';

 signal droInput : unsigned(droBits-1 downto 0);
 signal droVal : unsigned(droBits-1 downto 0) := (others => '0');
 signal droDist : signed(droBits-1 downto 0) := (others => '0');
 signal droEnd : unsigned(droBits-1 downto 0);
 signal decelLimit : unsigned(droBits-1 downto 0);

 signal posDout : std_logic;

 type droFSM is (idle, calcDist, chkDisable, chkDone);
 signal droState : droFSM := idle;


begin

 droPosReg: ShiftOp
  generic map(opVal => opBase + F_Ld_Dro,
              opBits => opBits,
              n => droBits)
  port map ( clk => clk,
             din => din,
             op => op,
             shift => dshift,
             data => droInput);

 droEndReg: ShiftOp
  generic map(opVal => opBase + F_Ld_Dro_End,
              opBits => opBits,
              n => droBits)
  port map ( clk => clk,
             din => din,
             op => op,
             shift => dshift,
             data => droEnd);

 droLimitReg: ShiftOp
  generic map(opVal => opBase + F_Ld_Dro_Limit,
              opBits => opBits,
              n => droBits)
  port map ( clk => clk,
             din => din,
             op => op,
             shift => dshift,
             data => decelLimit);

 dout <= posDout;

 LocShiftOut : ShiftOutNS
  generic map(opVal => opBase + F_Rd_Dro,
              opBits => opBits,
              n => droBits,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => dshiftR,
   op => opR,
   copy => copyR,
   data => unsigned(droVal),
   dout => posDout
   );


 droPorcess : process(clk)
  variable ch : std_logic;
 begin
  if (rising_edge(clk)) then

   ch := ((quadState(3) xor quadState(1)) or
          (quadState(2) xor quadState(0))); --input change   
   if (ch = '1') then
    case (quadState) is
     when "0001" => dir <= dirInvert; update <= '1';
     when "0111" => dir <= dirInvert; update <= '1';
     when "1110" => dir <= dirInvert; update <= '1';
     when "1000" => dir <= dirInvert; update <= '1';
     when "0010" => dir <= not dirInvert; update <= '1';
     when "1011" => dir <= not dirInvert; update <= '1';
     when "1101" => dir <= not dirInvert; update <= '1';
     when "0100" => dir <= not dirInvert; update <= '1';
     when others => update <= '0';
    end case;
   end if;                              --end change

   quadState <= quadState(1 downto 0) & b & a;

   if (load) then                       --if load

    droVal <= droInput;                 --set new value

   elsif (update = '1') then            --if update

    if (dir = '1') then                 --if positive direction
     droVal <= droVal + 1;              --increment position
    else                                --if negative direction
     droVal <= droVal - 1;              --decrement position
    end if;                             --end direction chekc

    if (endCheck = '1') then            --if using dro for end
     droState <= calcDist;              --start end check
    end if;
    
   end if;                              --end update

   case droState is                     --select state
    when idle => null;                  --idle

    when calcDist =>                    --calculate distance
     if ((update and endCheck) = '1') then --if using dro for end
      if (dir = '1') then               --if positive direction
       droDist <= signed(droEnd) - signed(droVal); --dist for pos Dir
      else                              --if negative direction
       droDist <= signed(droVal) - signed(droEnd); --dist for neg dir
      end if;
      droState <= chkDisable;
     end if;                            --end direction check

    when chkDisable =>                  --check for decel disable
     if (droDist < signed(decelLimit)) then
      decelDisable <= true;
     else
      decelDisable <= false;
     end if;
     droState <= chkDone;
     
    when chkDone =>                     --check for done
     if (droDist < to_signed(0, droBits)) then
      done <= true;
     else
      done <= false;
     end if;
     droState <= idle;

    when others =>
     droState <= idle;
   end case;

  end if;                               --end rising_edge

 end process;

end Behavioral;

