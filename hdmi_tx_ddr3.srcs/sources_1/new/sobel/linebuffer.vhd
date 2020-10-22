--*******************************************************************
-- Copyright(C) 2005 by Xilinx, Inc. All rights reserved.
-- This text/file contains proprietary, confidential
-- information of Xilinx, Inc., is distributed under license
-- from Xilinx, Inc., and may be used, copied and/or
-- disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc. Xilinx hereby grants you
-- a license to use this text/file solely for design, simulation,
-- implementation and creation of design files limited
-- to Xilinx devices or technologies. Use with non-Xilinx
-- devices or technologies is expressly prohibited and
-- immediately terminates your license unless covered by
-- a separate agreement.
--
-- Xilinx is providing this design, code, or information
-- "as is" solely for use in developing programs and
-- solutions for Xilinx devices. By providing this design,
-- code, or information as one possible implementation of
-- this feature, application or standard, Xilinx is making no
-- representation that this implementation is free from any
-- claims of infringement. You are responsible for
-- obtaining any rights you may require for your implementation.
-- Xilinx expressly disclaims any warranty whatsoever with
-- respect to the adequacy of the implementation, including
-- but not limited to any warranties or representations that this
-- implementation is free from claims of infringement, implied
-- warranties of merchantability or fitness for a particular
-- purpose.
--
-- Xilinx products are not intended for use in life support
-- appliances, devices, or systems. Use in such applications are
-- expressly prohibited.
--
-- This copyright and support notice must be retained as part
-- of this text at all times. (c) Copyright 2005 Xilinx, Inc.
-- All rights reserved.
--
--  Title:  ImageXlib_arch.vhd
--  Created:  September 2005
--  Author: Clive Walker
--
-- $RCSfile: ImageXlib_arch.vhd,v $ $Revision: 1.19 $ $Date: 2006/02/14 21:26:44 $
--
-- ************************************************************************      

-- *********************************************
--  *0000*   Dual Port BRAM Macro
--  dp_bram
--
-- *********************************************
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all; 
use work.imagexlib_utils.all;	

entity dp_bram is
   generic
   (
      data_width           :  integer  := 8;
      mem_size             :  integer  := 1920
	);
   port
	(
	   ce       :  in    std_logic;
      
      din      :  in    std_logic_vector((data_width - 1) downto 0);
	   wr_en    :  in    std_logic;
      wr_clk   :  in    std_logic;
      wr_addr  :  in    std_logic_vector((LOG2_BASE(mem_size) - 1) downto 0);

	   rd_en    :  in    std_logic;      
      rd_clk   :  in    std_logic;
      rd_addr  :  in    std_logic_vector((LOG2_BASE(mem_size) - 1) downto 0);

      dout     :  out   std_logic_vector((data_width - 1) downto 0)

   );
end dp_bram;

architecture rtl of dp_bram is
type     mem_array_type    is array (0 to (mem_size - 1)) of std_logic_vector((data_width - 1) downto 0);							
signal   mem_array         :  mem_array_type  := (others => (others => '0'));
attribute   ram_style      :  string;
attribute   ram_style      of mem_array : signal is "block";

begin

   process (wr_clk)
   begin
      if (wr_clk'event and wr_clk = '1') then
         if (ce = '1') then
            if (wr_en = '1') then
               mem_array(conv_integer('0' & wr_addr)) <= din;
            end if;
         end if;
      end if;
   end process;
   
   process (rd_clk)
   begin
      if (rd_clk'event and rd_clk = '1') then
         if (ce = '1') then
            if (rd_en = '1') then         
               dout <= mem_array(conv_integer('0' & rd_addr));
            end if;
         end if;
      end if;
   end process;
   
end rtl;

----------------------------------------------

-- *********************************************
--  *0001*   Line Buffer Macro
--  linebuffer
--
-- *********************************************
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all; 
use work.imagexlib_utils.all;	 

entity linebuffer is
   generic
   (
      data_width           :  integer  := 8;
      samples_per_line     :  integer  := 1000;
      no_of_lines          :  integer  := 3; -- In order to make 2D filter....
      feather_outputs      :  boolean  := true  
	);
   port
	(
      ce                :  in    std_logic;
      wr_clk            :  in    std_logic;
      wr_en             :  in    std_logic;
      wr_rst            :  in    std_logic;
      data_in           :  in    std_logic_vector((data_width - 1) downto 0);
      write_h_pointer   :  out   std_logic_vector((LOG2_BASE(samples_per_line) - 1) downto 0);
      last_wr_location  :  out   std_logic;
      rd_clk            :  in    std_logic;      
      rd_en             :  in    std_logic;
      rd_rst            :  in    std_logic;
      cascade_en        :  in    std_logic;
      read_h_pointer    :  out   std_logic_vector((LOG2_BASE(samples_per_line) - 1) downto 0);      
      last_rd_location  :  out   std_logic;
      data_out          :  out   std_logic_vector_array((no_of_lines - 1) downto 0)
   );
end linebuffer;

architecture rtl of linebuffer is

type     line_type            is array (0 to (samples_per_line - 1)) of std_logic_vector((data_width - 1) downto 0);
type     column_type          is array (0 to (no_of_lines - 1)) of std_logic_vector((data_width - 1) downto 0);

signal   hi                            :  std_logic := '1';
signal   d_data_in                     :  std_logic_vector((data_width - 1) downto 0);
constant pointer_width                 :  integer := LOG2_BASE(samples_per_line);
signal   t_write_h_pointer             :  std_logic_vector((pointer_width - 1) downto 0);
type     d_mem_dout_type               is array (0 to (no_of_lines - 1)) of column_type;
signal   d_mem_dout                    :  column_type;
signal   d2_mem_dout                   :  column_type;
signal   d_wr_en                       :  std_logic;
signal   d_rd_en                       :  std_logic_vector(no_of_lines  downto 0);
signal   app_wr_en                     :  std_logic_vector(no_of_lines  downto 0);
signal   d_cascade_en                  :  std_logic_vector(no_of_lines downto 0);
signal   mem_wr_en                     :  std_logic;
type     address_array_type            is array (no_of_lines downto 0) of std_logic_vector((pointer_width - 1) downto 0);
signal   d_read_h_pointer              :  address_array_type;
signal   app_rd_h_pointer              :  address_array_type;
signal   app_wr_h_pointer              :  address_array_type;
signal   d2_rd_en                      :  std_logic;
signal   d3_rd_en                      :  std_logic;


begin

write_h_pointer   <= t_write_h_pointer;
read_h_pointer    <= d_read_h_pointer(0);


-- Infer write-side control
wr_clk_process: process(wr_clk)
begin
   if (wr_clk'event and wr_clk = '1') then
      if (ce = '1') then 
         d_wr_en                       <= wr_en;
         d_data_in                     <= data_in; -- Initial register -
         if (wr_rst = '1') then
            t_write_h_pointer     <= (others => '0');
         elsif (d_wr_en = '1') then             
            if (t_write_h_pointer    = conv_std_logic_vector((samples_per_line - 1), pointer_width)) then
               t_write_h_pointer     <= (others => '0');
               last_wr_location     <= '1';
            else
               last_wr_location     <= '0';
               t_write_h_pointer     <= t_write_h_pointer + 1;
            end if;
         end if;
      end if;
   end if;
end process;

-- Infer memories
-- Note that the first line will be written using the write-side clock and enable, but subsequent memories will be 
-- written using the read-side clock and enable.
linebuf1 : entity work.dp_bram 
generic map
(
   data_width     => data_width,
   mem_size       => samples_per_line
)
port map
(
   ce             => ce,
   din            => d_data_in,
   wr_en          => d_wr_en,
   wr_clk         => wr_clk,
   wr_addr        => t_write_h_pointer,
   rd_en          => d_rd_en(0),   
   rd_clk         => rd_clk,
   rd_addr        => app_rd_h_pointer(0),
   dout           => d_mem_dout(0)
);

-- Cascade data from one line to another.
-- Allow for case where the cascade of line-buffers is not required - ie
-- data remains in the existing buffers available for potential reuse.
delay_cascade_en : process(rd_clk)
begin
   if (rd_clk'event and rd_clk = '1') then
      if (ce = '1') then
         d_cascade_en(0)  <= cascade_en;
         cascade_en_delay: for i in 1 to no_of_lines loop
            d_cascade_en(i)   <= d_cascade_en(i-1);
         end loop;
      end if;
   end if;
end process;



mem_array_wr : for i in 1 to (no_of_lines - 1) generate
   linebufn : entity work.dp_bram 
   generic map
   (
      data_width     => data_width,
      mem_size       => samples_per_line
   )
   port map
   (
      ce             => ce,
      din            => d2_mem_dout(i-1),
      wr_en          => app_wr_en(i),
      wr_clk         => rd_clk,
      wr_addr        => app_wr_h_pointer(i),
      rd_en          => d_rd_en(i),   
      rd_clk         => rd_clk,
      rd_addr        => app_rd_h_pointer(i),
      dout           => d_mem_dout(i)
   );

end generate;

define_applied_wr_control : for i in 1 to (no_of_lines - 1) generate
   app_wr_en(i)         <= (d3_rd_en and d_cascade_en(2)) when (feather_outputs = false) 
                                       else (d_rd_en(i+1) and d_cascade_en(i+1)) ;
   app_wr_h_pointer(i)  <= d_read_h_pointer(2) when (feather_outputs = false) else d_read_h_pointer(i+1);
end generate;

----------------------------------------------------------
-- Infer read-side control
rd_clk_process: process(rd_clk)
begin
   if (rd_clk'event and rd_clk = '1') then
      if (ce = '1') then 
         d2_mem_dout                      <= d_mem_dout;
         d_rd_en(0)                       <= rd_en;
         d2_rd_en                         <= d_rd_en(0);
         d3_rd_en                         <= d2_rd_en;
         -- Delay the read-enable for feathered-output case
         delay_rd_en_loop2 : for i in 1 to no_of_lines loop         
            if (feather_outputs = true) then
               d_rd_en(i)                    <= d_rd_en(i-1);
            else
               d_rd_en(i)                    <= rd_en;
            end if;
         end loop;
      
         -- Generate read-pointer
         if (rd_rst = '1') then
            d_read_h_pointer(0)     <= (others => '0');
         elsif (d_rd_en(0) = '1') then       
            if (d_read_h_pointer(0) = conv_std_logic_vector((samples_per_line - 1), pointer_width)) then
               d_read_h_pointer(0)     <= (others => '0');
               last_rd_location        <= '1';
            else
               last_rd_location        <= '0';
               d_read_h_pointer(0)     <= d_read_h_pointer(0) + 1;
            end if;
         end if;

         -- Delay the read-pointer for feathered-output case
         delay_d_read_h_pointer_loop : for i in 1 to no_of_lines loop
---            if (d_rd_en(i) = '1') then       
               d_read_h_pointer(i)           <= d_read_h_pointer(i-1);
---            end if;
         end loop;
      end if;
   end if;
end process;

define_applied_rd_pointer : for i in 0 to (no_of_lines - 1) generate
   app_rd_h_pointer(i) <= d_read_h_pointer(0) when (feather_outputs = false) else d_read_h_pointer(i);
end generate;
   

----------------------------------------------------------
-- Define output.
dout_gen : for i in 0 to (no_of_lines - 1) generate
   data_out(i)((data_width - 1) downto 0)	<= d_mem_dout(i);
end generate;

end rtl;