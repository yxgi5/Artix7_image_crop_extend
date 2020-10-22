-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
-- Date        : Thu Oct 15 12:27:54 2020
-- Host        : debian-dell running 64-bit Debian GNU/Linux 8.11 (jessie)
-- Command     : write_vhdl -force -mode synth_stub
--               /home/andy/workdir/hdmi_tx_ddr3_1pcs_1920_1080_dual_ov5640_640_480_32bit_128burst/hdmi_tx_ddr3.srcs/sources_1/ip/cfg_clock/cfg_clock_stub.vhdl
-- Design      : cfg_clock
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tfgg484-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cfg_clock is
  Port ( 
    clk_out1 : out STD_LOGIC;
    clk_out2 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end cfg_clock;

architecture stub of cfg_clock is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out1,clk_out2,reset,locked,clk_in1";
begin
end;
