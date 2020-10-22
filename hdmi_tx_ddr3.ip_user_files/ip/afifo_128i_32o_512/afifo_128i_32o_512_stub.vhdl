-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
-- Date        : Tue Oct  6 23:48:12 2020
-- Host        : debian-dell running 64-bit Debian GNU/Linux 8.11 (jessie)
-- Command     : write_vhdl -force -mode synth_stub
--               /home/andy/workdir/hdmi_tx_ddr3/hdmi_tx_ddr3.srcs/sources_1/ip/afifo_128i_32o_512/afifo_128i_32o_512_stub.vhdl
-- Design      : afifo_128i_32o_512
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tfgg484-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity afifo_128i_32o_512 is
  Port ( 
    rst : in STD_LOGIC;
    wr_clk : in STD_LOGIC;
    rd_clk : in STD_LOGIC;
    din : in STD_LOGIC_VECTOR ( 127 downto 0 );
    wr_en : in STD_LOGIC;
    rd_en : in STD_LOGIC;
    dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
    full : out STD_LOGIC;
    empty : out STD_LOGIC;
    rd_data_count : out STD_LOGIC_VECTOR ( 10 downto 0 );
    wr_data_count : out STD_LOGIC_VECTOR ( 8 downto 0 )
  );

end afifo_128i_32o_512;

architecture stub of afifo_128i_32o_512 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "rst,wr_clk,rd_clk,din[127:0],wr_en,rd_en,dout[31:0],full,empty,rd_data_count[10:0],wr_data_count[8:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "fifo_generator_v13_2_3,Vivado 2018.3";
begin
end;
