-- #################################################################################################
-- # << NEORV32 - Custom Functions Subsystem (CFS) >>                                              #
-- # ********************************************************************************************* #
-- # Intended for tightly-coupled, application-specific custom co-processors. This module provides #
-- # 64x 32-bit memory-mapped interface registers, one interrupt request signal and custom IO      #
-- # conduits for processor-external or chip-external interface.                                   #
-- #                                                                                               #
-- # NOTE: This is just an example/illustration template. Modify/replace this file to implement    #
-- #       your own custom design logic.                                                           #
-- # ********************************************************************************************* #
-- # BSD 3-Clause License                                                                          #
-- #                                                                                               #
-- # Copyright (c) 2023, Stephan Nolting. All rights reserved.                                     #
-- #                                                                                               #
-- # Redistribution and use in source and binary forms, with or without modification, are          #
-- # permitted provided that the following conditions are met:                                     #
-- #                                                                                               #
-- # 1. Redistributions of source code must retain the above copyright notice, this list of        #
-- #    conditions and the following disclaimer.                                                   #
-- #                                                                                               #
-- # 2. Redistributions in binary form must reproduce the above copyright notice, this list of     #
-- #    conditions and the following disclaimer in the documentation and/or other materials        #
-- #    provided with the distribution.                                                            #
-- #                                                                                               #
-- # 3. Neither the name of the copyright holder nor the names of its contributors may be used to  #
-- #    endorse or promote products derived from this software without specific prior written      #
-- #    permission.                                                                                #
-- #                                                                                               #
-- # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS   #
-- # OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF               #
-- # MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE    #
-- # COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,     #
-- # EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE #
-- # GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED    #
-- # AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING     #
-- # NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED  #
-- # OF THE POSSIBILITY OF SUCH DAMAGE.                                                            #
-- # ********************************************************************************************* #
-- # The NEORV32 Processor - https://github.com/stnolting/neorv32              (c) Stephan Nolting #
-- #################################################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library neorv32;
use neorv32.neorv32_package.all;
-- <
use neorv32.mpgRecord.all;
-- >

entity neorv32_cfs is
  generic (
    CFS_CONFIG   : std_ulogic_vector(31 downto 0); -- custom CFS configuration generic
    CFS_IN_SIZE  : natural; -- size of CFS input conduit in bits
  -- <
  CFS_OUT_SIZE : natural;        -- size of CFS output conduit in bits
  inputPins    : positive;
  xOutPins     : positive
  -- >
  );
  port (
   clk_i       : in  std_ulogic; -- global clock line
   rstn_i      : in  std_ulogic; -- global reset line, low-active, use as async
   bus_req_i   : in  bus_req_t;  -- bus request
   bus_rsp_o   : out bus_rsp_t := rsp_terminate_c; -- bus response
   clkgen_en_o : out std_ulogic := '0'; -- enable clock generator
   clkgen_i    : in  std_ulogic_vector(7 downto 0); -- "clock" inputs
   irq_o       : out std_ulogic := '0'; -- interrupt request
   cfs_in_i    : in  std_ulogic_vector(CFS_IN_SIZE-1 downto 0); -- custom inputs
   cfs_out_o   : out std_ulogic_vector(CFS_OUT_SIZE-1 downto 0) :=
   (others => '0'); -- custom outputs
   cfs_we_o    : out std_ulogic := '0';
   cfs_reg_o   : out std_ulogic_vector(2 downto 0) := (others => '0');
   cfs_dbg_o   : out std_ulogic_vector(xOutPins-1 downto 0):=
   (others => '0'); -- debug output
   cfs_mpg_i   : in  MpgQuadRec;
   cfs_pins_i  : in  std_ulogic_vector(inputPins-1 downto 0)
   -- >
   );
end neorv32_cfs;

architecture neorv32_cfs_rtl of neorv32_cfs is

  -- default CFS interface registers --
  type cfs_regs_t is array (0 to 3) of std_ulogic_vector(31 downto 0); -- just implement 4 registers for this example
  signal cfs_reg_wr : cfs_regs_t; -- interface registers for WRITE accesses
  signal cfs_reg_rd : cfs_regs_t; -- interface registers for READ accesses
-- <
 signal data : std_ulogic_vector(CFS_IN_SIZE-1 downto 0) := (others => '0');
 signal dbg  : std_ulogic_vector(xOutPins-1 downto 0) := (others => '0');
 
 constant divRange : integer := 50000-1;
 signal divider    : integer range 0 to divRange := divRange;
 signal millis     : unsigned(32-1 downto 0) := (others => '0');

 signal msTick     : std_logic := '0';

 constant mpgWidth : natural := 8;
 constant mpgDepth : natural := 16;

 constant dFill   : std_logic_vector(32-mpgWidth-2 downto 0) :=
  (others => '0');
 constant pinFill : std_ulogic_vector(32-inputPins-1 downto 0) :=
  (others => '0');
 constant dbgFill : std_ulogic_vector(32-xOutPins-1 downto 0) :=
  (others => '0');

 signal busAddr : std_ulogic_vector(6-1 downto 0);

 constant rsvSel    : std_ulogic_vector(6-1 downto 0) := "000000";
 constant ctlSel    : std_ulogic_vector(6-1 downto 0) := "000001";
 constant dataSel   : std_ulogic_vector(6-1 downto 0) := "000010";
 constant opSel     : std_ulogic_vector(6-1 downto 0) := "000011";
 constant millisSel : std_ulogic_vector(6-1 downto 0) := "000100";
 constant zMpgSel   : std_ulogic_vector(6-1 downto 0) := "000101";
 constant xMpgSel   : std_ulogic_vector(6-1 downto 0) := "000110";
 constant pinsSel   : std_ulogic_vector(6-1 downto 0) := "000111";
 constant dbgSel    : std_ulogic_vector(6-1 downto 0) := "001000";

 signal zEmpty : std_logic := '0';
 signal zData  : std_logic_vector(mpgWidth-1 downto 0) := (others => '0');
 signal reMpgZ : std_logic := '0';

 signal xEmpty : std_logic := '0';
 signal xData  : std_logic_vector(mpgWidth-1 downto 0) := (others => '0');
 signal reMpgX : std_logic := '0';
-- >
begin

 -- CFS Generics ---------------------------------------------------------------------------
 -- -------------------------------------------------------------------------------------------
 -- In it's default version the CFS provides three configuration generics:
 -- > CFS_IN_SIZE  - configures the size (in bits) of the CFS input conduit cfs_in_i
 -- > CFS_OUT_SIZE - configures the size (in bits) of the CFS output conduit cfs_out_o
 -- > CFS_CONFIG   - is a blank 32-bit generic. It is intended as a "generic conduit" to propagate
 --                  custom configuration flags from the top entity down to this module.


 -- CFS IOs --------------------------------------------------------------------------------
 -- -------------------------------------------------------------------------------------------
 -- By default, the CFS provides two IO signals (cfs_in_i and cfs_out_o) that are available at the processor's top entity.
 -- These are intended as "conduits" to propagate custom signals from this module and the processor top entity.

 -- cfs_out_o <= (others => '0'); -- not used for this minimal example
 -- <
 cfs_out_o <= data;
 -- >

 -- Reset System ---------------------------------------------------------------------------
 -- -------------------------------------------------------------------------------------------
 -- The CFS can be reset using the global rstn_i signal. This signal should be used as asynchronous reset and is active-low.
  -- Note that rstn_i can be asserted by a processor-external reset, the on-chip debugger and also by the watchdog.
  --
  -- Most default peripheral devices of the NEORV32 do NOT use a dedicated hardware reset at all. Instead, these units are
  -- reset by writing ZERO to a specific "control register" located right at the beginning of the device's address space
  -- (so this register is cleared at first). The crt0 start-up code writes ZERO to every single address in the processor's
  -- IO space - including the CFS. Make sure that this initial clearing does not cause any unintended CFS actions.


  -- Clock System ---------------------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  -- The processor top unit implements a clock generator providing 8 "derived clocks".
  -- Actually, these signals should not be used as direct clock signals, but as *clock enable* signals.
  -- clkgen_i is always synchronous to the main system clock (clk_i).
  --
  -- The following clock dividers are available:
  -- > clkgen_i(clk_div2_c)    -> MAIN_CLK/2
  -- > clkgen_i(clk_div4_c)    -> MAIN_CLK/4
  -- > clkgen_i(clk_div8_c)    -> MAIN_CLK/8
  -- > clkgen_i(clk_div64_c)   -> MAIN_CLK/64
  -- > clkgen_i(clk_div128_c)  -> MAIN_CLK/128
  -- > clkgen_i(clk_div1024_c) -> MAIN_CLK/1024
  -- > clkgen_i(clk_div2048_c) -> MAIN_CLK/2048
  -- > clkgen_i(clk_div4096_c) -> MAIN_CLK/4096
  --
  -- For instance, if you want to drive a clock process at MAIN_CLK/8 clock speed you can use the following construct:
  --
  --   if (rstn_i = '0') then -- async and low-active reset (if required at all)
  --   ...
  --   elsif rising_edge(clk_i) then -- always use the main clock for all clock processes
  --     if (clkgen_i(clk_div8_c) = '1') then -- the div8 "clock" is actually a clock enable
  --       ...
  --     end if;
  --   end if;
  --
  -- The clkgen_i input clocks are available when at least one IO/peripheral device (for example UART0) requires the clocks
  -- generated by the clock generator. The CFS can enable the clock generator by itself by setting the clkgen_en_o signal high.
  -- The CFS cannot ensure to deactivate the clock generator by setting the clkgen_en_o signal low as other peripherals might
  -- still keep the generator activated. Make sure to deactivate the CFS's clkgen_en_o if no clocks are required in here to
  -- reduce dynamic power consumption.

  clkgen_en_o <= '0'; -- not used for this minimal example


  -- Interrupt ------------------------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  -- The CFS features a single interrupt signal, which is connected to the CPU's "fast interrupt" channel 1 (FIRQ1).
  -- The interrupt is triggered by a one-cycle high-level. After triggering, the interrupt appears as "pending" in the CPU's
  -- mip CSR ready to trigger execution of the according interrupt handler. It is the task of the application to programmer
  -- to enable/clear the CFS interrupt using the CPU's mie and mip registers when required.

  irq_o <= '0'; -- not used for this minimal example


  -- Read/Write Access ----------------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  -- Here we are reading/writing from/to the interface registers of the module and generate the CPU access handshake (bus response).
  --
  -- The CFS provides up to 64 memory-mapped 32-bit interface registers. For instance, these could be used to provide a
  -- <control register> for global control of the unit, a <data register> for reading/writing from/to a data FIFO, a
  -- <command register> for issuing commands and a <status register> for status information.
  --
  -- Following the interface protocol, each read or write access has to be acknowledged in the following cycle using the ack_o
  -- signal (or even later if the module needs additional time). If no ACK is generated at all, the bus access will time out
  -- and cause a bus access fault exception. The current CPU privilege level is available via the 'priv_i' signal (0 = user mode,
  -- 1 = machine mode), which can be used to constrain access to certain registers or features to privileged software only.
  --
  -- This module also provides an optional ERROR signal to indicate a faulty access operation (for example when accessing an
  -- unused, read-only or "locked" CFS register address). This signal may only be set when the module is actually accessed
  -- and is set INSTEAD of the ACK signal. Setting the ERR signal will raise a bus access exception with a "Device Error" qualifier
  -- that can be handled by the application software. Note that the current privilege level should not be exposed to software to
  -- maintain full virtualization. Hence, CFS-based "privilege escalation" should trigger a bus access exception (e.g. by setting 'err_o').
  --
  -- Host access example: Read and write access to the interface registers + bus transfer acknowledge. This example only
  -- implements four physical r/w register (the four lowest CFS registers). The remaining addresses of the CFS are not associated
  -- with any physical registers - any access to those is simply ignored but still acknowledged. Only full-word write accesses are
  -- supported (and acknowledged) by this example. Sub-word write access will not alter any CFS register state and will cause
  -- a "bus store access" exception (with a "Device Timeout" qualifier as not ACK is generated in that case).


 -- <
 cfs_dbg_o <= dbg;

 busAddr <= bus_req_i.addr(8-1 downto 2);

 reMpgZ <= '1' when  (bus_req_i.rw = '0') and  (busAddr = zMpgSel)
           else '0';

 mpgZ : entity neorv32.Mpg
  generic map(mpgDepth => mpgDepth,
              mpgWidth => mpgWidth)
  port map (
   clk    => clk_i,
   init   => rstn_i,
   msTick => msTick,
   re     => reMpgZ,
   empty  => zEmpty,
   mpg    => cfs_mpg_i.zQuad,
   rData  => zData
   );

 reMpgX <= '1' when  (bus_req_i.rw = '0') and  (busAddr = xMpgSel)
           else '0';

 mpgX : entity neorv32.Mpg
  generic map(mpgDepth => mpgDepth,
              mpgWidth => mpgWidth)
  port map (
   clk    => clk_i,
   init   => rstn_i,
   msTick => msTick,
   re     => reMpgX,
   empty  => xEmpty,
   mpg    => cfs_mpg_i.xQuad,
   rData  => xData
   );

 divProcess : process(clk_i)
 begin
  if (rising_edge(clk_i)) then          --if clock active
   -- msTick <= not msTick;
   if (divider = 0) then
    divider <= divRange;
    millis <= millis + 1;
    msTick <= '1';
   else
    divider <= divider - 1;
    msTick <= '0';
   end if;
  end if;
 end process;
 -- >

  bus_access: process(rstn_i, clk_i)
  begin
   if (rstn_i = '0') then
    -- cfs_reg_wr(0) <= (others => '0');
    -- cfs_reg_wr(1) <= (others => '0');
    -- cfs_reg_wr(2) <= (others => '0');
    -- cfs_reg_wr(3) <= (others => '0');
    --
    bus_rsp_o.ack  <= '0';
    bus_rsp_o.err  <= '0';
    bus_rsp_o.data <= (others => '0');
   elsif rising_edge(clk_i) then -- synchronous interface for read and write accesses
    -- transfer/access acknowledge --
    bus_rsp_o.ack <= bus_req_i.stb;

    -- tie to zero if not explicitly used --
    bus_rsp_o.err <= '0';

    -- defaults --
    -- bus_rsp_o.data <= (others => '0'); -- the output HAS TO BE ZERO if there is no actual (read) acces

    -- bus access --
    if (bus_req_i.stb = '1') then -- valid access cycle, STB is high for one cycle

     -- write access --
     if (bus_req_i.rw = '1') then
      -- <
      cfs_we_o <= '1';
      cfs_reg_o <= bus_req_i.addr(4 downto 2);

      case busAddr is
       when rsvSel    => data <= bus_req_i.data;
       when ctlSel    => data <= bus_req_i.data;
       when dataSel   => data <= bus_req_i.data;
       when opsel     => data <= bus_req_i.data;
       when millisSel => null;
       when zMpgSel   => null;
       when xMpgSel   => null;
       when pinsSel   => null;
       when dbgSel    => dbg <= bus_req_i.data(xOutPins-1 downto 0);
       when others    => null;
      end case;
      -- >
      -- if (bus_req_i.addr(7 downto 2) = "000000") then -- address size is fixed!
      --   cfs_reg_wr(0) <= bus_req_i.data;
      -- end if;
      -- if (bus_req_i.addr(7 downto 2) = "000001") then
      --   cfs_reg_wr(1) <= bus_req_i.data; -- some physical register, for example: data in/out fifo
      -- end if;
      -- if (bus_req_i.addr(7 downto 2) = "000010") then
      --   cfs_reg_wr(2) <= bus_req_i.data; -- some physical register, for example: command fifo
      -- end if;
      -- if (bus_req_i.addr(7 downto 2) = "000011") then
      --   cfs_reg_wr(3) <= bus_req_i.data; -- some physical register, for example: status register
      -- end if;

     -- read access --
     else
      -- case bus_req_i.addr(7 downto 2) is -- address size is fixed!
      --   when "000000" => bus_rsp_o.data <= cfs_reg_rd(0);
      --   when "000001" => bus_rsp_o.data <= cfs_reg_rd(1);
      --   when "000010" => bus_rsp_o.data <= cfs_reg_rd(2);
      --   when "000011" => bus_rsp_o.data <= cfs_reg_rd(3);
      -- <
      case busAddr is
       when rsvSel    => bus_rsp_o.data <= data;
       when ctlSel    => bus_rsp_o.data <= data;
       when dataSel   => bus_rsp_o.data <= cfs_in_i;
       when opsel     => bus_rsp_o.data <= data;
       when millisSel => bus_rsp_o.data <= std_ulogic_vector(millis);
       when zMpgSel   => bus_rsp_o.data <= std_ulogic_vector(dFill & zEmpty & zData);
       when xMpgSel   => bus_rsp_o.data <= std_ulogic_vector(dFill & xEmpty & xData);
       when pinsSel   => bus_rsp_o.data <= pinFill & cfs_pins_i;
       when dbgSel    => bus_rsp_o.data <= dbgFill & dbg;    
       -- >                   
       when others    => bus_rsp_o.data <= (others => '0');
      end case; 
     end if;
    -- <
    else
     bus_rsp_o.data <= (others => '0');
     cfs_we_o <= '0';
    -- >
    end if;
   end if;
  end process bus_access;


  -- CFS Function Core ----------------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------

  -- This is where the actual functionality can be implemented.
  -- The logic below is just a very simple example that transforms data
  -- from an input register into data in an output register.

  -- cfs_reg_rd(0) <= bin_to_gray_f(cfs_reg_wr(0)); -- convert binary to gray code
  -- cfs_reg_rd(1) <= gray_to_bin_f(cfs_reg_wr(1)); -- convert gray to binary code
  -- cfs_reg_rd(2) <= bit_rev_f(cfs_reg_wr(2)); -- bit reversal
  -- cfs_reg_rd(3) <= bswap32_f(cfs_reg_wr(3)); -- byte swap (endianness conversion)


end neorv32_cfs_rtl;
