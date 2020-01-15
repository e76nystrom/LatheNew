--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:30:59 01/25/2015 
-- Design Name: 
-- Module Name:    SPI - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SPI is
 generic (opBits : positive := 8);
 port (
  clk : in std_logic;                   --system clock
  dclk : in std_logic;                  --spi clk
  dsel : in std_logic;                  --spi select
  din : in std_logic;                   --spi data in
  op : out unsigned(opBits-1 downto 0) := (others => '0'); --op code
  copy : out boolean := false;          --copy data to be shifted out
  shift : out boolean := false;         --shift data
  load : out boolean := false;          --load data shifted in
  header : out boolean := true;         --receiving header
  spiActive : out boolean := false
  --info : out std_logic_vector(2 downto 0) --state info
  );
end SPI;

architecture Behavioral of SPI is

 component ClockEnableN is
 generic (n : positive);
  Port (
   clk : in  std_logic;
   ena : in  std_logic;
   clkena : out std_logic);
 end component;

 type spi_fsm is (start, idle, read_hdr, chk_count, upd_count, copy_data,
                  active, dclk_wait, load_reg);
 signal state : spi_fsm := start;

 signal count : integer range 0 to opBits := opBits;
 signal opReg : unsigned(opbits-1 downto 0) := (others => '0');

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

 clk_ena: ClockEnableN
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
      op <= (opBits-1 downto 0 => '0');
      state <= idle;
     end if;

    when idle =>
     shift <= false;
     load <= false;
     copy <= false;
     if (dselEna) then
      header <= true;
      spiActive <= true;
      msgData <= false;
      opReg <= (opBits-1 downto 0 => '0');
      count <= opBits;
      state <= read_hdr;
     else
      spiActive <= false;
     end if;

    when read_hdr =>
     if (dselDis) then
      state <= idle;
     else
      if (clkena = '1') then
       opReg <= opReg(opBits-2 downto 0) & din;
       state <= upd_count;
      end if;
     end if;

    when upd_count =>
     count <= count - 1;
     state <= chk_count;

    when chk_count =>
     if (count = 0) then
      op <= opReg;
      header <= false;
      state <= copy_data;
     else
      state <= read_hdr;
     end if;

    when copy_data =>
     copy <= true;
     state <= active;

    when active =>
     copy <= false;
     if (dselDis) then
      if (msgdata) then
       msgData <= false;
       load <= true;
       state <= load_reg;
      end if;
     else
      if (clkena = '1') then
       msgData <= True;
       shift <= true;
       state <= dclk_wait;
      end if;
     end if;

    when dclk_wait =>
     shift <= false;
     state <= active;
 
    when load_reg =>
     load <= false;
     op <= to_unsigned(0, opBits);
     state <= idle;

   end case;
  end if;
 end process;

end Behavioral;
