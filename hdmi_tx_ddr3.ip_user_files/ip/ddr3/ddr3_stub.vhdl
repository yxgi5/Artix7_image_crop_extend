-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
-- Date        : Thu Oct 15 13:30:35 2020
-- Host        : debian-dell running 64-bit Debian GNU/Linux 8.11 (jessie)
-- Command     : write_vhdl -force -mode synth_stub
--               /home/andy/workdir/hdmi_tx_ddr3_1pcs_1920_1080_dual_ov5640_640_480_32bit_128burst/hdmi_tx_ddr3.srcs/sources_1/ip/ddr3/ddr3_stub.vhdl
-- Design      : ddr3
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tfgg484-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ddr3 is
  Port ( 
    ddr3_dq : inout STD_LOGIC_VECTOR ( 15 downto 0 );
    ddr3_dqs_n : inout STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr3_dqs_p : inout STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr3_addr : out STD_LOGIC_VECTOR ( 14 downto 0 );
    ddr3_ba : out STD_LOGIC_VECTOR ( 2 downto 0 );
    ddr3_ras_n : out STD_LOGIC;
    ddr3_cas_n : out STD_LOGIC;
    ddr3_we_n : out STD_LOGIC;
    ddr3_reset_n : out STD_LOGIC;
    ddr3_ck_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_ck_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_cke : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_cs_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_dm : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr3_odt : out STD_LOGIC_VECTOR ( 0 to 0 );
    sys_clk_i : in STD_LOGIC;
    app_addr : in STD_LOGIC_VECTOR ( 28 downto 0 );
    app_cmd : in STD_LOGIC_VECTOR ( 2 downto 0 );
    app_en : in STD_LOGIC;
    app_wdf_data : in STD_LOGIC_VECTOR ( 127 downto 0 );
    app_wdf_end : in STD_LOGIC;
    app_wdf_mask : in STD_LOGIC_VECTOR ( 15 downto 0 );
    app_wdf_wren : in STD_LOGIC;
    app_rd_data : out STD_LOGIC_VECTOR ( 127 downto 0 );
    app_rd_data_end : out STD_LOGIC;
    app_rd_data_valid : out STD_LOGIC;
    app_rdy : out STD_LOGIC;
    app_wdf_rdy : out STD_LOGIC;
    app_sr_req : in STD_LOGIC;
    app_ref_req : in STD_LOGIC;
    app_zq_req : in STD_LOGIC;
    app_sr_active : out STD_LOGIC;
    app_ref_ack : out STD_LOGIC;
    app_zq_ack : out STD_LOGIC;
    ui_clk : out STD_LOGIC;
    ui_clk_sync_rst : out STD_LOGIC;
    init_calib_complete : out STD_LOGIC;
    device_temp : out STD_LOGIC_VECTOR ( 11 downto 0 );
    sys_rst : in STD_LOGIC
  );

end ddr3;

architecture stub of ddr3 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "ddr3_dq[15:0],ddr3_dqs_n[1:0],ddr3_dqs_p[1:0],ddr3_addr[14:0],ddr3_ba[2:0],ddr3_ras_n,ddr3_cas_n,ddr3_we_n,ddr3_reset_n,ddr3_ck_p[0:0],ddr3_ck_n[0:0],ddr3_cke[0:0],ddr3_cs_n[0:0],ddr3_dm[1:0],ddr3_odt[0:0],sys_clk_i,app_addr[28:0],app_cmd[2:0],app_en,app_wdf_data[127:0],app_wdf_end,app_wdf_mask[15:0],app_wdf_wren,app_rd_data[127:0],app_rd_data_end,app_rd_data_valid,app_rdy,app_wdf_rdy,app_sr_req,app_ref_req,app_zq_req,app_sr_active,app_ref_ack,app_zq_ack,ui_clk,ui_clk_sync_rst,init_calib_complete,device_temp[11:0],sys_rst";
begin
end;
