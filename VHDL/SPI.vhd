-- Create Date:    07:30:59 01/25/2015 

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;

use work.RegDef.opb;

entity SPI is
 port (
  clk   : in std_logic;                 --system clock
  dclk  : in std_logic;                 --spi clk
  dsel  : in std_logic;                 --spi select
  din   : in std_logic;                 --spi data in
  op    : out unsigned(opb-1 downto 0) := (others => '0'); --op code
  copy  : out std_logic := '0';         --copy data to be shifted out
  shift : out std_logic := '0';         --shift data
  load  : out std_logic := '0';         --load data shifted in
  spiActive : out std_logic := '0'
  --info : out std_logic_vector(2 downto 0) --state info
  );
end SPI;

architecture Behavioral of SPI is

 type spi_fsm is (start, idle, read_hdr, chk_count, upd_count, copy_data,
                  active, dclk_wait, load_reg);
 signal state : spi_fsm := start;

 signal count : integer range 0 to opb := opb;
 signal opReg : unsigned(opb-1 downto 0) := (others => '0');

 signal clkena : std_logic;
 constant n : positive := 4;
 signal dseldly : std_logic_vector(n-1 downto 0) := (others => '1');
 signal dselEna : boolean := false;
 signal dselDis : boolean := false;
 signal msgData : boolean := false;

 --function convert(a: spi_fsm) return std_logic_vector is
 --begin
 -- case a is
 --  when start     => return("111");
 --  when idle      => return("000");
 --  when read_hdr  => return("001");
 --  when chk_count => return("010");
 --  when upd_count => return("011");
 --  when active    => return("100");
 --  when dclk_wait => return("101");
 --  when load_reg  => return("110");
 --  when others    => null;
 -- end case;
 -- return("000");
 --end;

begin

 --info <= convert(state);

 clk_ena : entity work.ClockEnableN
  generic map(n => 4)
  port map (
   clk => clk,
   ena => dclk,
   clkena =>clkena);

 dselEna <= True when dseldly = (n-1 downto 0 => '0') else False;
 dselDis <= True when dseldly = (n-1 downto 0 => '1') else False;

 din_proc: process(clk)
 begin
  if (rising_edge(clk)) then
   dseldly <= dseldly(n-2 downto 0) & dsel;
   case state is
    when start =>
     if (dselDis) then
      op <= (opb-1 downto 0 => '0');
      state <= idle;
     end if;

    when idle =>
     shift <= '0';
     load <= '0';
     copy <= '0';
     if (dselEna) then
      spiActive <= '1';
      msgData <= false;
      opReg <= (opb-1 downto 0 => '0');
      count <= opb;
      state <= read_hdr;
     else
      spiActive <= '0';
     end if;

    when read_hdr =>
     if (dselDis) then
      state <= idle;
     else
      if (clkena = '1') then
       opReg <= opReg(opb-2 downto 0) & din;
       state <= upd_count;
      end if;
     end if;

    when upd_count =>
     count <= count - 1;
     state <= chk_count;

    when chk_count =>
     if (count = 0) then
      op <= opReg;
      state <= copy_data;
     else
      state <= read_hdr;
     end if;

    when copy_data =>
     copy <= '1';
     state <= active;

    when active =>
     copy <= '0';
     if (dselDis) then
      if (msgdata) then
       msgData <= false;
       load <= '1';
       state <= load_reg;
      end if;
     else
      if (clkena = '1') then
       msgData <= True;
       shift <= '1';
       state <= dclk_wait;
      end if;
     end if;

    when dclk_wait =>
     shift <= '0';
     state <= active;
 
    when load_reg =>
     load <= '0';
     op <= to_unsigned(0, opb);
     state <= idle;

   end case;
  end if;
 end process;

end Behavioral;
