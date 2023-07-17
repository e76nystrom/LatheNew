-- Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
-- Component : Spix
-- Git hash  : 134e8bbe19952eeed8cd19a9b69dffb7d14849cd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

package pkg_enum is
  type spiFsm_enumDef is (BOOT,start,idle,readHdr,updCount,chkCount,copyData,active,dClkWait,loadReg);

  function pkg_mux (sel : std_logic; one : spiFsm_enumDef; zero : spiFsm_enumDef) return spiFsm_enumDef;
  function pkg_toStdLogicVector_native (value : spiFsm_enumDef) return std_logic_vector;
  function pkg_tospiFsm_enumDef_native (value : std_logic_vector(3 downto 0)) return spiFsm_enumDef;
end pkg_enum;

package body pkg_enum is
  function pkg_mux (sel : std_logic; one : spiFsm_enumDef; zero : spiFsm_enumDef) return spiFsm_enumDef is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_tospiFsm_enumDef_native (value : std_logic_vector(3 downto 0)) return spiFsm_enumDef is
  begin
    case value is
      when "0000" => return BOOT;
      when "0001" => return start;
      when "0010" => return idle;
      when "0011" => return readHdr;
      when "0100" => return updCount;
      when "0101" => return chkCount;
      when "0110" => return copyData;
      when "0111" => return active;
      when "1000" => return dClkWait;
      when "1001" => return loadReg;
      when others => return BOOT;
    end case;
  end;
  function pkg_toStdLogicVector_native (value : spiFsm_enumDef) return std_logic_vector is
  begin
    case value is
      when BOOT => return "0000";
      when start => return "0001";
      when idle => return "0010";
      when readHdr => return "0011";
      when updCount => return "0100";
      when chkCount => return "0101";
      when copyData => return "0110";
      when active => return "0111";
      when dClkWait => return "1000";
      when loadReg => return "1001";
      when others => return "0000";
    end case;
  end;
end pkg_enum;


library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package pkg_scala2hdl is
  function pkg_extract (that : std_logic_vector; bitId : integer) return std_logic;
  function pkg_extract (that : std_logic_vector; base : unsigned; size : integer) return std_logic_vector;
  function pkg_cat (a : std_logic_vector; b : std_logic_vector) return std_logic_vector;
  function pkg_not (value : std_logic_vector) return std_logic_vector;
  function pkg_extract (that : unsigned; bitId : integer) return std_logic;
  function pkg_extract (that : unsigned; base : unsigned; size : integer) return unsigned;
  function pkg_cat (a : unsigned; b : unsigned) return unsigned;
  function pkg_not (value : unsigned) return unsigned;
  function pkg_extract (that : signed; bitId : integer) return std_logic;
  function pkg_extract (that : signed; base : unsigned; size : integer) return signed;
  function pkg_cat (a : signed; b : signed) return signed;
  function pkg_not (value : signed) return signed;

  function pkg_mux (sel : std_logic; one : std_logic; zero : std_logic) return std_logic;
  function pkg_mux (sel : std_logic; one : std_logic_vector; zero : std_logic_vector) return std_logic_vector;
  function pkg_mux (sel : std_logic; one : unsigned; zero : unsigned) return unsigned;
  function pkg_mux (sel : std_logic; one : signed; zero : signed) return signed;

  function pkg_toStdLogic (value : boolean) return std_logic;
  function pkg_toStdLogicVector (value : std_logic) return std_logic_vector;
  function pkg_toUnsigned (value : std_logic) return unsigned;
  function pkg_toSigned (value : std_logic) return signed;
  function pkg_stdLogicVector (lit : std_logic_vector) return std_logic_vector;
  function pkg_unsigned (lit : unsigned) return unsigned;
  function pkg_signed (lit : signed) return signed;

  function pkg_resize (that : std_logic_vector; width : integer) return std_logic_vector;
  function pkg_resize (that : unsigned; width : integer) return unsigned;
  function pkg_resize (that : signed; width : integer) return signed;

  function pkg_extract (that : std_logic_vector; high : integer; low : integer) return std_logic_vector;
  function pkg_extract (that : unsigned; high : integer; low : integer) return unsigned;
  function pkg_extract (that : signed; high : integer; low : integer) return signed;

  function pkg_shiftRight (that : std_logic_vector; size : natural) return std_logic_vector;
  function pkg_shiftRight (that : std_logic_vector; size : unsigned) return std_logic_vector;
  function pkg_shiftLeft (that : std_logic_vector; size : natural) return std_logic_vector;
  function pkg_shiftLeft (that : std_logic_vector; size : unsigned) return std_logic_vector;

  function pkg_shiftRight (that : unsigned; size : natural) return unsigned;
  function pkg_shiftRight (that : unsigned; size : unsigned) return unsigned;
  function pkg_shiftLeft (that : unsigned; size : natural) return unsigned;
  function pkg_shiftLeft (that : unsigned; size : unsigned) return unsigned;

  function pkg_shiftRight (that : signed; size : natural) return signed;
  function pkg_shiftRight (that : signed; size : unsigned) return signed;
  function pkg_shiftLeft (that : signed; size : natural) return signed;
  function pkg_shiftLeft (that : signed; size : unsigned; w : integer) return signed;

  function pkg_rotateLeft (that : std_logic_vector; size : unsigned) return std_logic_vector;
end  pkg_scala2hdl;

package body pkg_scala2hdl is
  function pkg_extract (that : std_logic_vector; bitId : integer) return std_logic is
    alias temp : std_logic_vector(that'length-1 downto 0) is that;
  begin
    if bitId >= temp'length then
      return 'U';
    end if;
    return temp(bitId);
  end pkg_extract;

  function pkg_extract (that : std_logic_vector; base : unsigned; size : integer) return std_logic_vector is
    alias temp : std_logic_vector(that'length-1 downto 0) is that;    constant elementCount : integer := temp'length - size + 1;
    type tableType is array (0 to elementCount-1) of std_logic_vector(size-1 downto 0);
    variable table : tableType;
  begin
    for i in 0 to elementCount-1 loop
      table(i) := temp(i + size - 1 downto i);
    end loop;
    if base + size >= elementCount then
      return (size-1 downto 0 => 'U');
    end if;
    return table(to_integer(base));
  end pkg_extract;

  function pkg_cat (a : std_logic_vector; b : std_logic_vector) return std_logic_vector is
    variable cat : std_logic_vector(a'length + b'length-1 downto 0);
  begin
    cat := a & b;
    return cat;
  end pkg_cat;

  function pkg_not (value : std_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(value'length-1 downto 0);
  begin
    ret := not value;
    return ret;
  end pkg_not;

  function pkg_extract (that : unsigned; bitId : integer) return std_logic is
    alias temp : unsigned(that'length-1 downto 0) is that;
  begin
    if bitId >= temp'length then
      return 'U';
    end if;
    return temp(bitId);
  end pkg_extract;

  function pkg_extract (that : unsigned; base : unsigned; size : integer) return unsigned is
    alias temp : unsigned(that'length-1 downto 0) is that;    constant elementCount : integer := temp'length - size + 1;
    type tableType is array (0 to elementCount-1) of unsigned(size-1 downto 0);
    variable table : tableType;
  begin
    for i in 0 to elementCount-1 loop
      table(i) := temp(i + size - 1 downto i);
    end loop;
    if base + size >= elementCount then
      return (size-1 downto 0 => 'U');
    end if;
    return table(to_integer(base));
  end pkg_extract;

  function pkg_cat (a : unsigned; b : unsigned) return unsigned is
    variable cat : unsigned(a'length + b'length-1 downto 0);
  begin
    cat := a & b;
    return cat;
  end pkg_cat;

  function pkg_not (value : unsigned) return unsigned is
    variable ret : unsigned(value'length-1 downto 0);
  begin
    ret := not value;
    return ret;
  end pkg_not;

  function pkg_extract (that : signed; bitId : integer) return std_logic is
    alias temp : signed(that'length-1 downto 0) is that;
  begin
    if bitId >= temp'length then
      return 'U';
    end if;
    return temp(bitId);
  end pkg_extract;

  function pkg_extract (that : signed; base : unsigned; size : integer) return signed is
    alias temp : signed(that'length-1 downto 0) is that;    constant elementCount : integer := temp'length - size + 1;
    type tableType is array (0 to elementCount-1) of signed(size-1 downto 0);
    variable table : tableType;
  begin
    for i in 0 to elementCount-1 loop
      table(i) := temp(i + size - 1 downto i);
    end loop;
    if base + size >= elementCount then
      return (size-1 downto 0 => 'U');
    end if;
    return table(to_integer(base));
  end pkg_extract;

  function pkg_cat (a : signed; b : signed) return signed is
    variable cat : signed(a'length + b'length-1 downto 0);
  begin
    cat := a & b;
    return cat;
  end pkg_cat;

  function pkg_not (value : signed) return signed is
    variable ret : signed(value'length-1 downto 0);
  begin
    ret := not value;
    return ret;
  end pkg_not;


  -- unsigned shifts
  function pkg_shiftRight (that : unsigned; size : natural) return unsigned is
    variable ret : unsigned(that'length-1 downto 0);
  begin
    if size >= that'length then
      return "";
    else
      ret := shift_right(that,size);
      return ret(that'length-1-size downto 0);
    end if;
  end pkg_shiftRight;

  function pkg_shiftRight (that : unsigned; size : unsigned) return unsigned is
    variable ret : unsigned(that'length-1 downto 0);
  begin
    ret := shift_right(that,to_integer(size));
    return ret;
  end pkg_shiftRight;

  function pkg_shiftLeft (that : unsigned; size : natural) return unsigned is
  begin
    return shift_left(resize(that,that'length + size),size);
  end pkg_shiftLeft;

  function pkg_shiftLeft (that : unsigned; size : unsigned) return unsigned is
  begin
    return shift_left(resize(that,that'length + 2**size'length - 1),to_integer(size));
  end pkg_shiftLeft;

  -- std_logic_vector shifts
  function pkg_shiftRight (that : std_logic_vector; size : natural) return std_logic_vector is
  begin
    return std_logic_vector(pkg_shiftRight(unsigned(that),size));
  end pkg_shiftRight;

  function pkg_shiftRight (that : std_logic_vector; size : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(pkg_shiftRight(unsigned(that),size));
  end pkg_shiftRight;

  function pkg_shiftLeft (that : std_logic_vector; size : natural) return std_logic_vector is
  begin
    return std_logic_vector(pkg_shiftLeft(unsigned(that),size));
  end pkg_shiftLeft;

  function pkg_shiftLeft (that : std_logic_vector; size : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(pkg_shiftLeft(unsigned(that),size));
  end pkg_shiftLeft;

  -- signed shifts
  function pkg_shiftRight (that : signed; size : natural) return signed is
  begin
    return signed(pkg_shiftRight(unsigned(that),size));
  end pkg_shiftRight;

  function pkg_shiftRight (that : signed; size : unsigned) return signed is
  begin
    return shift_right(that,to_integer(size));
  end pkg_shiftRight;

  function pkg_shiftLeft (that : signed; size : natural) return signed is
  begin
    return signed(pkg_shiftLeft(unsigned(that),size));
  end pkg_shiftLeft;

  function pkg_shiftLeft (that : signed; size : unsigned; w : integer) return signed is
  begin
    return shift_left(resize(that,w),to_integer(size));
  end pkg_shiftLeft;

  function pkg_rotateLeft (that : std_logic_vector; size : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(rotate_left(unsigned(that),to_integer(size)));
  end pkg_rotateLeft;

  function pkg_extract (that : std_logic_vector; high : integer; low : integer) return std_logic_vector is
    alias temp : std_logic_vector(that'length-1 downto 0) is that;
  begin
    return temp(high downto low);
  end pkg_extract;

  function pkg_extract (that : unsigned; high : integer; low : integer) return unsigned is
    alias temp : unsigned(that'length-1 downto 0) is that;
  begin
    return temp(high downto low);
  end pkg_extract;

  function pkg_extract (that : signed; high : integer; low : integer) return signed is
    alias temp : signed(that'length-1 downto 0) is that;
  begin
    return temp(high downto low);
  end pkg_extract;

  function pkg_mux (sel : std_logic; one : std_logic; zero : std_logic) return std_logic is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : std_logic_vector; zero : std_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(zero'range);
  begin
    if sel = '1' then
      ret := one;
    else
      ret := zero;
    end if;
    return ret;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : unsigned; zero : unsigned) return unsigned is
    variable ret : unsigned(zero'range);
  begin
    if sel = '1' then
      ret := one;
    else
      ret := zero;
    end if;
    return ret;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : signed; zero : signed) return signed is
    variable ret : signed(zero'range);
  begin
    if sel = '1' then
      ret := one;
    else
      ret := zero;
    end if;
    return ret;
  end pkg_mux;

  function pkg_toStdLogic (value : boolean) return std_logic is
  begin
    if value = true then
      return '1';
    else
      return '0';
    end if;
  end pkg_toStdLogic;

  function pkg_toStdLogicVector (value : std_logic) return std_logic_vector is
    variable ret : std_logic_vector(0 downto 0);
  begin
    ret(0) := value;
    return ret;
  end pkg_toStdLogicVector;

  function pkg_toUnsigned (value : std_logic) return unsigned is
    variable ret : unsigned(0 downto 0);
  begin
    ret(0) := value;
    return ret;
  end pkg_toUnsigned;

  function pkg_toSigned (value : std_logic) return signed is
    variable ret : signed(0 downto 0);
  begin
    ret(0) := value;
    return ret;
  end pkg_toSigned;

  function pkg_stdLogicVector (lit : std_logic_vector) return std_logic_vector is
    alias ret : std_logic_vector(lit'length-1 downto 0) is lit;
  begin
    return std_logic_vector(ret);
  end pkg_stdLogicVector;

  function pkg_unsigned (lit : unsigned) return unsigned is
    alias ret : unsigned(lit'length-1 downto 0) is lit;
  begin
    return unsigned(ret);
  end pkg_unsigned;

  function pkg_signed (lit : signed) return signed is
    alias ret : signed(lit'length-1 downto 0) is lit;
  begin
    return signed(ret);
  end pkg_signed;

  function pkg_resize (that : std_logic_vector; width : integer) return std_logic_vector is
  begin
    return std_logic_vector(resize(unsigned(that),width));
  end pkg_resize;

  function pkg_resize (that : unsigned; width : integer) return unsigned is
    variable ret : unsigned(width-1 downto 0);
  begin
    if that'length = 0 then
       ret := (others => '0');
    else
       ret := resize(that,width);
    end if;
    return ret;
  end pkg_resize;
  function pkg_resize (that : signed; width : integer) return signed is
    alias temp : signed(that'length-1 downto 0) is that;
    variable ret : signed(width-1 downto 0);
  begin
    if temp'length = 0 then
       ret := (others => '0');
    elsif temp'length >= width then
       ret := temp(width-1 downto 0);
    else
       ret := resize(temp,width);
    end if;
    return ret;
  end pkg_resize;
end pkg_scala2hdl;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity Spix is
  port(
    io_dClk : in std_logic;
    io_dSel : in std_logic;
    io_dIn : in std_logic;
    io_op : out std_logic_vector(7 downto 0);
    io_copy : out std_logic;
    io_shift : out std_logic;
    io_load : out std_logic;
    io_header : out std_logic;
    io_spiActive : out std_logic;
    clk : in std_logic;
    reset : in std_logic
  );
end Spix;

architecture arch of Spix is

  signal opReg : std_logic_vector(7 downto 0) := "00000000";
  signal copy : std_logic := '0';
  signal shift : std_logic := '0';
  signal load : std_logic := '0';
  signal header : std_logic := '0';
  signal spiActive : std_logic := '0';
  signal msgData : std_logic := '0';
  signal count : unsigned(3 downto 0) := "0000";
  signal clkEna : std_logic;
  signal clkDly : std_logic_vector(7 downto 0) := "00000000";
  signal dSelDly : std_logic_vector(3 downto 0) := "0000";
  signal dSelEna : std_logic;
  signal dSelDis : std_logic;
  signal spiFsm_wantExit : std_logic;
  signal spiFsm_wantStart : std_logic;
  signal spiFsm_wantKill : std_logic;
  signal spiFsm_stateReg : spiFsm_enumDef;
  signal spiFsm_stateNext : spiFsm_enumDef;
  signal when_Spix_l130 : std_logic;
  signal when_StateMachine_l237 : std_logic;
  signal when_StateMachine_l237_1 : std_logic;
begin
  clkEna <= pkg_toStdLogic(clkDly = pkg_cat(pkg_stdLogicVector("0000"),pkg_stdLogicVector("1111")));
  dSelEna <= pkg_toStdLogic(dSelDly = pkg_stdLogicVector("0000"));
  dSelDis <= pkg_toStdLogic(dSelDly = pkg_stdLogicVector("1111"));
  spiFsm_wantExit <= pkg_toStdLogic(false);
  process(spiFsm_stateReg)
  begin
    spiFsm_wantStart <= pkg_toStdLogic(false);
    case spiFsm_stateReg is
      when pkg_enum.start =>
      when pkg_enum.idle =>
      when pkg_enum.readHdr =>
      when pkg_enum.updCount =>
      when pkg_enum.chkCount =>
      when pkg_enum.copyData =>
      when pkg_enum.active =>
      when pkg_enum.dClkWait =>
      when pkg_enum.loadReg =>
      when others =>
        spiFsm_wantStart <= pkg_toStdLogic(true);
    end case;
  end process;

  spiFsm_wantKill <= pkg_toStdLogic(false);
  process(opReg,spiFsm_stateReg,when_Spix_l130)
  begin
    io_op <= opReg;
    case spiFsm_stateReg is
      when pkg_enum.start =>
      when pkg_enum.idle =>
      when pkg_enum.readHdr =>
      when pkg_enum.updCount =>
      when pkg_enum.chkCount =>
        if when_Spix_l130 = '1' then
          io_op <= opReg;
        end if;
      when pkg_enum.copyData =>
      when pkg_enum.active =>
      when pkg_enum.dClkWait =>
      when pkg_enum.loadReg =>
      when others =>
    end case;
  end process;

  io_copy <= copy;
  io_shift <= shift;
  io_load <= load;
  io_header <= header;
  io_spiActive <= spiActive;
  process(spiFsm_stateReg,dSelDis,dSelEna,clkEna,when_Spix_l130,msgData,spiFsm_wantStart,spiFsm_wantKill)
  begin
    spiFsm_stateNext <= spiFsm_stateReg;
    case spiFsm_stateReg is
      when pkg_enum.start =>
        if dSelDis = '1' then
          spiFsm_stateNext <= pkg_enum.idle;
        end if;
      when pkg_enum.idle =>
        if dSelEna = '1' then
          spiFsm_stateNext <= pkg_enum.readHdr;
        end if;
      when pkg_enum.readHdr =>
        if dSelDis = '1' then
          spiFsm_stateNext <= pkg_enum.idle;
        else
          if clkEna = '1' then
            spiFsm_stateNext <= pkg_enum.updCount;
          end if;
        end if;
      when pkg_enum.updCount =>
        spiFsm_stateNext <= pkg_enum.chkCount;
      when pkg_enum.chkCount =>
        if when_Spix_l130 = '1' then
          spiFsm_stateNext <= pkg_enum.copyData;
        else
          spiFsm_stateNext <= pkg_enum.readHdr;
        end if;
      when pkg_enum.copyData =>
        spiFsm_stateNext <= pkg_enum.active;
      when pkg_enum.active =>
        if dSelDis = '1' then
          if msgData = '1' then
            spiFsm_stateNext <= pkg_enum.loadReg;
          end if;
        else
          if clkEna = '1' then
            spiFsm_stateNext <= pkg_enum.dClkWait;
          end if;
        end if;
      when pkg_enum.dClkWait =>
        spiFsm_stateNext <= pkg_enum.active;
      when pkg_enum.loadReg =>
        spiFsm_stateNext <= pkg_enum.idle;
      when others =>
    end case;
    if spiFsm_wantStart = '1' then
      spiFsm_stateNext <= pkg_enum.start;
    end if;
    if spiFsm_wantKill = '1' then
      spiFsm_stateNext <= pkg_enum.BOOT;
    end if;
  end process;

  when_Spix_l130 <= pkg_toStdLogic(count = pkg_unsigned("0000"));
  when_StateMachine_l237 <= (pkg_toStdLogic(spiFsm_stateReg = pkg_enum.start) and (not pkg_toStdLogic(spiFsm_stateNext = pkg_enum.start)));
  when_StateMachine_l237_1 <= (pkg_toStdLogic(spiFsm_stateReg = pkg_enum.idle) and (not pkg_toStdLogic(spiFsm_stateNext = pkg_enum.idle)));
  process(clk)
  begin
    if rising_edge(clk) then
      clkDly <= pkg_cat(pkg_extract(clkDly,6,0),pkg_toStdLogicVector(io_dClk));
      if io_dClk = '1' then
        clkDly <= pkg_cat(pkg_extract(clkDly,6,0),pkg_stdLogicVector("1"));
      else
        clkDly <= pkg_stdLogicVector("00000000");
      end if;
      dSelDly <= pkg_cat(pkg_extract(dSelDly,2,0),pkg_toStdLogicVector(io_dSel));
      case spiFsm_stateReg is
        when pkg_enum.start =>
          header <= pkg_toStdLogic(false);
          spiActive <= pkg_toStdLogic(false);
        when pkg_enum.idle =>
          copy <= pkg_toStdLogic(false);
          shift <= pkg_toStdLogic(false);
          load <= pkg_toStdLogic(false);
          if dSelEna = '0' then
            spiActive <= pkg_toStdLogic(false);
          end if;
        when pkg_enum.readHdr =>
          if dSelDis = '0' then
            if clkEna = '1' then
              opReg <= pkg_cat(pkg_extract(opReg,6,0),pkg_toStdLogicVector(io_dIn));
            end if;
          end if;
        when pkg_enum.updCount =>
          count <= (count - pkg_unsigned("0001"));
        when pkg_enum.chkCount =>
          if when_Spix_l130 = '1' then
            header <= pkg_toStdLogic(false);
          end if;
        when pkg_enum.copyData =>
          copy <= pkg_toStdLogic(true);
        when pkg_enum.active =>
          copy <= pkg_toStdLogic(false);
          if dSelDis = '1' then
            if msgData = '1' then
              msgData <= pkg_toStdLogic(false);
              load <= pkg_toStdLogic(true);
            end if;
          else
            if clkEna = '1' then
              msgData <= pkg_toStdLogic(true);
              shift <= pkg_toStdLogic(true);
            end if;
          end if;
        when pkg_enum.dClkWait =>
          shift <= pkg_toStdLogic(false);
        when pkg_enum.loadReg =>
          load <= pkg_toStdLogic(false);
          opReg <= pkg_stdLogicVector("00000000");
        when others =>
      end case;
      if when_StateMachine_l237 = '1' then
        opReg <= pkg_stdLogicVector("00000000");
      end if;
      if when_StateMachine_l237_1 = '1' then
        header <= pkg_toStdLogic(true);
        spiActive <= pkg_toStdLogic(true);
        msgData <= pkg_toStdLogic(false);
        opReg <= pkg_stdLogicVector("00000000");
        count <= pkg_unsigned("1000");
      end if;
    end if;
  end process;

  process(clk, reset)
  begin
    if reset = '1' then
      spiFsm_stateReg <= pkg_enum.BOOT;
    elsif rising_edge(clk) then
      spiFsm_stateReg <= spiFsm_stateNext;
    end if;
  end process;

end arch;

