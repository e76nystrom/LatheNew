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

entity neorv32_cfs is
 generic (
  CFS_CONFIG   : std_ulogic_vector(31 downto 0); -- custom CFS configuration generic

  CFS_IN_SIZE  : natural;        -- size of CFS input conduit in bits
  CFS_OUT_SIZE : natural         -- size of CFS output conduit in bits
  );
 port (
  clk_i       : in  std_ulogic; -- global clock line
  rstn_i      : in  std_ulogic; -- global reset line, low-active, use as async
  bus_req_i   : in  bus_req_t;  -- bus request
  bus_rsp_o   : out bus_rsp_t;  -- bus response
  clkgen_en_o : out std_ulogic; -- enable clock generator
  clkgen_i    : in  std_ulogic_vector(07 downto 0); -- "clock" inputs
  irq_o       : out std_ulogic; -- interrupt request

  cfs_in_i    : in  std_ulogic_vector(CFS_IN_SIZE-1 downto 0); -- custom inputs
  cfs_out_o   : out std_ulogic_vector(CFS_OUT_SIZE-1 downto 0); -- custom outputs

  cfs_we_o    : out std_ulogic := '0';
  cfs_reg_o   : out std_ulogic_vector(2 downto 0) := (others => '0')

  );
end neorv32_cfs;

architecture neorv32_cfs_rtl of neorv32_cfs is

 signal data : std_ulogic_vector(CFS_IN_SIZE-1 downto 0);
 
 constant divRange : integer := 50000-1;

 signal divider : integer range 0 to divRange := divRange;
 signal millis  : unsigned(32-1 downto 0) := (others => '0');
 
begin

 cfs_out_o <= data;
 clkgen_en_o <= '0';            -- not used for this minimal example
 irq_o <= '0';                  -- not used for this minimal example
 bus_rsp_o.err <= '0';          -- Tie to zero if not explicitly used.

 divProcess : process(clk_i)
 begin
  if (rising_edge(clk_i)) then          --if clock active
   if (divider = 0) then
    divider <= divRange;
    millis <= millis + 1;
   else
    divider <= divider - 1;
   end if;
  end if;
 end process;

 host_access: process(rstn_i, clk_i)
 begin
  if (rstn_i = '0') then
   -- cfs_reg_wr(0) <= (others => '0');
   -- cfs_reg_wr(1) <= (others => '0');
   -- cfs_reg_wr(2) <= (others => '0');
   -- cfs_reg_wr(3) <= (others => '0');
   --
   bus_rsp_o.ack  <= '0';
   bus_rsp_o.data <= (others => '0');
  elsif rising_edge(clk_i) then -- synchronous interface for read and write accesses
   cfs_we_o <= bus_req_i.we;
   cfs_reg_o <= bus_req_i.addr(4 downto 2);
   bus_rsp_o.ack <= bus_req_i.re or bus_req_i.we;

   -- write access --
   if (bus_req_i.we = '1') then
    data <= bus_req_i.data;
   -- if (bus_req_i.addr(7 downto 2) = "000000") then
   --   cfs_reg_wr(0) <= bus_req_i.data;
   -- end if;
   -- if (bus_req_i.addr(7 downto 2) = "000001") then
   --   cfs_reg_wr(1) <= bus_req_i.data;
   -- end if;
   -- if (bus_req_i.addr(7 downto 2) = "000010") then
   --   cfs_reg_wr(2) <= bus_req_i.data;
   -- end if;
   -- if (bus_req_i.addr(7 downto 2) = "000011") then
   --   cfs_reg_wr(3) <= bus_req_i.data;
   -- end if;
   end if;

   -- read access --
   bus_rsp_o.data <= (others => '0');
   if (bus_req_i.re = '1') then
    -- if (bus_req_i.addr(4 downto 2) = "000") then
    --  bus_rsp_o.data <= data;
    -- else
    --  bus_rsp_o.data <= cfs_in_i;
    -- end if;
   case bus_req_i.addr(7 downto 2) is
     when "000000" => bus_rsp_o.data <= data;
     when "000001" => bus_rsp_o.data <= data;
     when "000010" => bus_rsp_o.data <= cfs_in_i;
     when "000011" => bus_rsp_o.data <= data;
     when "000100" => bus_rsp_o.data <= std_ulogic_vector(millis);
     when others   => bus_rsp_o.data <= (others => '0');
   end case;
   end if;
  end if;
 end process host_access;

end neorv32_cfs_rtl;
