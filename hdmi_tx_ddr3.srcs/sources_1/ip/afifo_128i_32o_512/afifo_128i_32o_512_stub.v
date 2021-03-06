// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
// Date        : Tue Oct  6 23:48:12 2020
// Host        : debian-dell running 64-bit Debian GNU/Linux 8.11 (jessie)
// Command     : write_verilog -force -mode synth_stub
//               /home/andy/workdir/hdmi_tx_ddr3/hdmi_tx_ddr3.srcs/sources_1/ip/afifo_128i_32o_512/afifo_128i_32o_512_stub.v
// Design      : afifo_128i_32o_512
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tfgg484-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_3,Vivado 2018.3" *)
module afifo_128i_32o_512(rst, wr_clk, rd_clk, din, wr_en, rd_en, dout, full, 
  empty, rd_data_count, wr_data_count)
/* synthesis syn_black_box black_box_pad_pin="rst,wr_clk,rd_clk,din[127:0],wr_en,rd_en,dout[31:0],full,empty,rd_data_count[10:0],wr_data_count[8:0]" */;
  input rst;
  input wr_clk;
  input rd_clk;
  input [127:0]din;
  input wr_en;
  input rd_en;
  output [31:0]dout;
  output full;
  output empty;
  output [10:0]rd_data_count;
  output [8:0]wr_data_count;
endmodule
