-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
-- Date        : Tue Oct  6 19:33:40 2020
-- Host        : debian-dell running 64-bit Debian GNU/Linux 8.11 (jessie)
-- Command     : write_vhdl -force -mode synth_stub
--               /home/andy/workdir/ddr3_an5642_hdmi_sobel_2018/ddr3_an5642_hdmi_sobel.srcs/sources_1/ip/clk_200M/clk_200M_stub.vhdl
-- Design      : clk_200M
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tfgg484-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_200M is
  Port ( 
    clk_out1 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end clk_200M;

architecture stub of clk_200M is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out1,reset,locked,clk_in1";
begin
end;
