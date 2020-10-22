//////////////////////////////////////////////////////////////////////////////////
//  ov5640 lcd display                                                          //
//                                                                              //
//  Author: lhj                                                                 //
//                                                                              //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//          heijin                                                              //
//     WEB: http://www.alinx.cn/                                                //
//     BBS: http://www.heijin.org/                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
// Copyright (c) 2017,ALINX(shanghai) Technology Co.,Ltd                        //
//                    All rights reserved                                       //
//                                                                              //
// This source file may be used and distributed without restriction provided    //
// that this copyright statement is not removed from the file and that any      //
// derivative work contains the original copyright notice and the associated    //
// disclaimer.                                                                  //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

//================================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------------
//  2019/08/14     meisq          1.0         Original
//*******************************************************************************/

module top(
//input                            key2,                   // camera change
//input                            sys_clk,                //system clock 50Mhz on board
input 				             sys_clk_p 		,
input				             sys_clk_n 		, 
input                            rst_n,                  //reset input，low active
////COMS1
//inout                            cmos1_scl,              //cmos i2c clock
//inout                            cmos1_sda,              //cmos i2c data
//input                            cmos1_vsync,            //cmos vsync
//input                            cmos1_href,             //cmos hsync refrence,data valid
//input                            cmos1_pclk,             //cmos pxiel clock
//input   [9:0]                    cmos1_d,                //cmos data
//output                           cmos1_rst_n,            //cmos reset
////COMS2      
//inout                            cmos2_scl,              //cmos i2c clock
//inout                            cmos2_sda,              //cmos i2c data
//input                            cmos2_vsync,            //cmos vsync
//input                            cmos2_href,             //cmos hsync refrence,data valid
//input                            cmos2_pclk,             //cmos pxiel clock
//input   [9:0]                    cmos2_d,                //cmos data
//output                           cmos2_rst_n,            //cmos reset

//ddr3
inout [15:0]                     ddr3_dq,                //ddr3 data
inout [1:0]                      ddr3_dqs_n,             //ddr3 dqs negative
inout [1:0]                      ddr3_dqs_p,             //ddr3 dqs positive
// Outputs
//output [13:0]                       ddr3_addr,              //ddr3 address // for MT41J128M16HA-125
output [14:0]                    ddr3_addr,              //ddr3 address // for MT41K256M16TW-107
output [2:0]                     ddr3_ba,                //ddr3 bank
output                           ddr3_ras_n,             //ddr3 ras_n
output                           ddr3_cas_n,             //ddr3 cas_n
output                           ddr3_we_n,              //ddr3 write enable
output                           ddr3_reset_n,           //ddr3 reset,
output [0:0]                     ddr3_ck_p,              //ddr3 clock negative
output [0:0]                     ddr3_ck_n,              //ddr3 clock positive
output [0:0]                     ddr3_cke,               //ddr3_cke,
output [0:0]                     ddr3_cs_n,              //ddr3 chip select,
output [1:0]                     ddr3_dm,                //ddr3_dm
output [0:0]                     ddr3_odt,                //ddr3_odt

//// Inouts
//inout [31:0]                        ddr3_dq,                //ddr3 data
//inout [3:0]                         ddr3_dqs_n,             //ddr3 dqs negative
//inout [3:0]                         ddr3_dqs_p,             //ddr3 dqs positive
//// Outputs
//output [14:0]                       ddr3_addr,              //ddr3 address
//output [2:0]                        ddr3_ba,                //ddr3 bank
//output                              ddr3_ras_n,             //ddr3 ras_n
//output                              ddr3_cas_n,             //ddr3 cas_n
//output                              ddr3_we_n,              //ddr3 write enable
//output                              ddr3_reset_n,           //ddr3 reset,
//output [0:0]                        ddr3_ck_p,              //ddr3 clock negative
//output [0:0]                        ddr3_ck_n,              //ddr3 clock positive
//output [0:0]                        ddr3_cke,               //ddr3_cke,
//output [0:0]                        ddr3_cs_n,              //ddr3 chip select,
//output [3:0]                        ddr3_dm,                //ddr3_dm
//output [0:0]                        ddr3_odt,               //ddr3_odt

//hdmi output 
//output [0:0]                     HDMI_OEN,                //HDMI out enable
//output                           tmds_clk_p,              //HDMI differential clock positive
//output                           tmds_clk_n,              //HDMI differential clock negative
//output [2:0]                     tmds_data_n,             //HDMI differential data negative
//output [2:0]                     tmds_data_p              //HDMI differential data positive    

//hdmi tx port
output              hdmi_tx_clk   ,
output              hdmi_tx_de    ,
output              hdmi_tx_vs    ,
output              hdmi_tx_hs    ,
output      [23:0]  hdmi_td       ,

//cfg port
output              hdmi_scl      ,
inout               hdmi_sda      ,
output              cmos1_scl      ,
inout               cmos1_sda      ,
output              cmos2_scl      ,
inout               cmos2_sda      ,

//ov5640 port
input               cmos1_pclk     ,
input               cmos1_vsync    ,
input               cmos1_href     ,
output              cmos1_rst_n    ,
input        [9:0]  cmos1_data     //,

//input               cmos2_pclk     ,
//input               cmos2_vsync    ,
//input               cmos2_href     ,
//output              cmos2_rst_n    ,
//input        [9:0]  cmos2_data     
);

//localparam nCK_PER_CLK              = 4;
//localparam DQ_WIDTH                 = 16;
//localparam ADDR_WIDTH               = 28;
//localparam DATA_WIDTH               = 16;
//localparam PAYLOAD_WIDTH            = 16;

////localparam nCK_PER_CLK              = 4;
////localparam DQ_WIDTH                 = 32;
////localparam ADDR_WIDTH               = 29;
////localparam DATA_WIDTH               = 32;
////localparam PAYLOAD_WIDTH            = 32;

//localparam APP_DATA_WIDTH           = 2 * nCK_PER_CLK * PAYLOAD_WIDTH;
//localparam APP_MASK_WIDTH           = APP_DATA_WIDTH / 8;

parameter MEM_DATA_BITS          = 128;                 //external memory user interface data width
parameter ADDR_BITS              = 28;                  //external memory user interface address width
parameter BUSRT_BITS             = 10;                  //external memory user interface burst width

wire                             wr_burst_data_req;      // write burst data request       
wire                             wr_burst_finish;        // write burst finish flag
wire                             rd_burst_finish;        //read burst finish flag
wire                             rd_burst_req;           //read burst request
wire                             wr_burst_req;           //write burst request
wire[BUSRT_BITS - 1:0]           rd_burst_len;           //read burst length
wire[BUSRT_BITS - 1:0]           wr_burst_len;           //write burst length
wire[ADDR_BITS - 1:0]            rd_burst_addr;          //read burst address
wire[ADDR_BITS - 1:0]            wr_burst_addr;          //write burst address
wire                             rd_burst_data_valid;    //read burst data valid
wire[MEM_DATA_BITS - 1 : 0]      rd_burst_data;          //read burst data
wire[MEM_DATA_BITS - 1 : 0]      wr_burst_data;          //write burst data

wire                             ch0_wr_burst_data_req;      // write burst data request       
wire                             ch0_wr_burst_finish;        // write burst finish flag
wire                             ch0_rd_burst_finish;        //read burst finish flag
wire                             ch0_rd_burst_req;           //read burst request
wire                             ch0_wr_burst_req;           //write burst request
wire[BUSRT_BITS - 1:0]           ch0_rd_burst_len;           //read burst length
wire[BUSRT_BITS - 1:0]           ch0_wr_burst_len;           //write burst length
wire[ADDR_BITS - 1:0]            ch0_rd_burst_addr;          //read burst address
wire[ADDR_BITS - 1:0]            ch0_wr_burst_addr;          //write burst address
wire                             ch0_rd_burst_data_valid;    //read burst data valid
wire[MEM_DATA_BITS - 1 : 0]      ch0_rd_burst_data;          //read burst data
wire[MEM_DATA_BITS - 1 : 0]      ch0_wr_burst_data;          //write burst data

wire                             ch1_wr_burst_data_req;      // write burst data request       
wire                             ch1_wr_burst_finish;        // write burst finish flag
wire                             ch1_rd_burst_finish;        //read burst finish flag
wire                             ch1_rd_burst_req;           //read burst request
wire                             ch1_wr_burst_req;           //write burst request
wire[BUSRT_BITS - 1:0]           ch1_rd_burst_len;           //read burst length
wire[BUSRT_BITS - 1:0]           ch1_wr_burst_len;           //write burst length
wire[ADDR_BITS - 1:0]            ch1_rd_burst_addr;          //read burst address
wire[ADDR_BITS - 1:0]            ch1_wr_burst_addr;          //write burst address
wire                             ch1_rd_burst_data_valid;    //read burst data valid
wire[MEM_DATA_BITS - 1 : 0]      ch1_rd_burst_data;          //read burst data
wire[MEM_DATA_BITS - 1 : 0]      ch1_wr_burst_data;          //write burst data

wire                             ch0_read_req;               //read request
wire                             ch0_read_req_ack;           //read request response  
wire                             ch0_read_en;                //read enable
wire[63:0]                       ch0_read_data;              //read data
wire                             ch0_write_en;               //write enable
wire[63:0]                       ch0_write_data;             //write data
wire[63:0]                       ch0_write_data_r;             //write data
wire                             ch0_write_req;              //write request
wire                             ch0_write_req_ack;          //write request response

wire                             ch1_read_req;               //read request
wire                             ch1_read_req_ack;           //read request response  
wire                             ch1_read_en;                //read enable
wire[63:0]                       ch1_read_data;              //read data
wire                             ch1_write_en;               //write enable
wire[63:0]                       ch1_write_data;             //write data
wire[63:0]                       ch1_write_data_r;             //write data
wire                             ch1_write_req;              //write request
wire                             ch1_write_req_ack;          //write request response

//wire                             video_clk;              //video pixel clock
//wire                             video_clk5x;            //5 x pixel clock
//wire                             hs;                     //horizontal synchronization
//wire                             vs;                     //vertical synchronization
//wire                             de;                     //video valid

wire[15:0]                      cmos_16bit_data;         //camera  data
wire                            cmos_16bit_wr;           //camera  write enable

wire[1:0]                       ch0_write_addr_index;        //write address index
wire[1:0]                       ch0_read_addr_index;         //write address index

wire[1:0]                       ch1_write_addr_index;        //write address index
wire[1:0]                       ch1_read_addr_index;         //write address index

wire                            ui_clk;                  //MIG master clock
wire                            ui_clk_sync_rst;         //MIG master reset
wire                            init_calib_complete;     //MIG initialization omplete
// Master Write Address
wire [3:0]                      s00_axi_awid;
wire [63:0]                     s00_axi_awaddr;
wire [7:0]                      s00_axi_awlen;           // burst length: 0-255
wire [2:0]                      s00_axi_awsize;          // burst size: fixed 2'b011
wire [1:0]                      s00_axi_awburst;         // burst type: fixed 2'b01(incremental burst)
wire                            s00_axi_awlock;          // lock: fixed 2'b00
wire [3:0]                      s00_axi_awcache;         // cache: fiex 2'b0011
wire [2:0]                      s00_axi_awprot;          // protect: fixed 2'b000
wire [3:0]                      s00_axi_awqos;           // qos: fixed 2'b0000
wire [0:0]                      s00_axi_awuser;          // user: fixed 32'd0
wire                            s00_axi_awvalid;
wire                            s00_axi_awready;
// master write data
wire [63:0]                     s00_axi_wdata;
wire [7:0]                      s00_axi_wstrb;
wire                            s00_axi_wlast;
wire [0:0]                      s00_axi_wuser;
wire                            s00_axi_wvalid;
wire                            s00_axi_wready;
// master write response
wire [3:0]                      s00_axi_bid;
wire [1:0]                      s00_axi_bresp;
wire [0:0]                      s00_axi_buser;
wire                            s00_axi_bvalid;
wire                            s00_axi_bready;
// master read address
wire [3:0]                      s00_axi_arid;
wire [63:0]                     s00_axi_araddr;
wire [7:0]                      s00_axi_arlen;
wire [2:0]                      s00_axi_arsize;
wire [1:0]                      s00_axi_arburst;
wire [1:0]                      s00_axi_arlock;
wire [3:0]                      s00_axi_arcache;
wire [2:0]                      s00_axi_arprot;
wire [3:0]                      s00_axi_arqos;
wire [0:0]                      s00_axi_aruser;
wire                            s00_axi_arvalid;
wire                            s00_axi_arready;
// master read data
wire [3:0]                      s00_axi_rid;
wire [63:0]                     s00_axi_rdata;
wire [1:0]                      s00_axi_rresp;
wire                            s00_axi_rlast;
wire [0:0]                      s00_axi_ruser;
wire                            s00_axi_rvalid;
wire                            s00_axi_rready;

wire [ADDR_BITS-1:0]               app_addr;
wire [2:0]                          app_cmd;
wire                                app_en;
wire                                app_rdy;
wire [MEM_DATA_BITS-1:0]           app_rd_data;
wire                                app_rd_data_end;
wire                                app_rd_data_valid;
wire [MEM_DATA_BITS-1:0]           app_wdf_data;
wire                                app_wdf_end;
wire [MEM_DATA_BITS/8-1:0]           app_wdf_mask;
wire                                app_wdf_rdy;
wire                                app_sr_active;
wire                                app_ref_ack;
wire                                app_zq_ack;
wire                                app_wdf_wren;

wire                            clk_200MHz;

wire[9:0]                       cmos1_lut_index;         //camera coms1 look up table address
wire[31:0]                      cmos1_lut_data;          //camera coms1 Device address,register address, register data
wire[9:0]                       cmos2_lut_index;         //camera coms2 look up table address
wire[31:0]                      cmos2_lut_data;          //camera coms2 Device address,register address, register data

wire                            hdmi_hs;                 //hdmi horizontal synchronization
wire                            hdmi_vs;                 //hdmi vertical synchronization
wire                            hdmi_de;                 //hdmi data valid
wire[7:0]                       hdmi_r;                  //hdmi red data
wire[7:0]                       hdmi_g;                  //hdmi green data
wire[7:0]                       hdmi_b;                  //hdmi blue data
wire[7:0]                       sobel_out;               //sobel data
wire[7:0]                       ycbcr_y;                 //ycbcr y data
wire                            ycbcr_hs;                //ycbcr horizontal synchronization
wire                            ycbcr_vs;                //ycbcr vertical synchronization
wire                            ycbcr_de;                //ycbcr valid
wire                            sobel_hs;                //sobel horizontal synchronization
wire                            sobel_vs;                //sobel vertical synchronization
wire                            sobel_de;                //sobel valid
assign hdmi_hs = sobel_hs;
assign hdmi_vs = sobel_vs;
assign hdmi_de = sobel_de;
assign hdmi_r  = sobel_out[7:0];
assign hdmi_g  = sobel_out[7:0];
assign hdmi_b  = sobel_out[7:0];
//assign HDMI_OEN    =1'b1;

//assign cmos1_rst_n = 1'b1;
//assign cmos2_rst_n = 1'b1;

//assign write_en = cmos_16bit_wr;
//assign write_data = {cmos_16bit_data[4:0],cmos_16bit_data[10:5],cmos_16bit_data[15:11]};

/*************************************************************************
generate clock for the MIG
****************************************************************************/
//clk_200M clk_refm0
//(
//.clk_in1                        (sys_clk                  ),
//.clk_out1                       (clk_200MHz               ),
//.reset                          (1'b0                     ),
//.locked                         (                         )
//);
IBUFDS sys_clock
(
  .O(clk_200MHz),
  .I(sys_clk_p),
  .IB(sys_clk_n)
);

wire      clk_50MHz;
wire      sys_clk;
assign    sys_clk =  clk_50MHz;
wire      hdmi_pclk;
//wire      cmos_pclk;
cfg_clock inst1_cfg_clock
(
    .clk_out1       (clk_50MHz),    // output clk_out1
    .clk_out2       (hdmi_pclk),    // output clk_out2 for hdmi
//    .clk_out3       (cmos_pclk),    // output clk_out3 for colorbar
    .reset          (~rst_n),          // input reset
    .locked         (),        // output locked
    .clk_in1        (clk_200MHz)       // input clk_in1
);

/*************************************************************************
generate video pixel clock
****************************************************************************/
//video_pll video_pll_m0
//(
//.clk_in1                        (sys_clk                  ),
//.clk_out1                       (video_clk                ),
//.clk_out2                       (video_clk5x              ),
//.reset                          (1'b0                     ),
//.locked                         (                         )
//);
/*************************************************************************
Configure the register of camera coms1
****************************************************************************/
//i2c_config i2c_config_m0
//(
//.rst                            (~rst_n                   ),
//.clk                            (sys_clk                  ),
//.clk_div_cnt                    (16'd99                   ),
//.i2c_addr_2byte                 (1'b1                     ),
//.lut_index                      (cmos1_lut_index          ),
//.lut_dev_addr                   (cmos1_lut_data[31:24]    ),
//.lut_reg_addr                   (cmos1_lut_data[23:8]     ),
//.lut_reg_data                   (cmos1_lut_data[7:0]      ),
//.error                          (                         ),
//.done                           (                         ),
//.i2c_scl                        (cmos1_scl                ),
//.i2c_sda                        (cmos1_sda                )
//);
/*************************************************************************
look-up table of camera coms1 
****************************************************************************/
//lut_ov5640_rgb565_1024_768 lut_ov5640_rgb565_1024_768_m0
//(
//.lut_index                      (cmos1_lut_index          ),
//.lut_data                       (cmos1_lut_data           )
//); 

/*************************************************************************
Configure the register of camera coms2
****************************************************************************/
//i2c_config i2c_config_m1
//(
//.rst                            (~rst_n                   ),
//.clk                            (sys_clk                  ),
//.clk_div_cnt                    (16'd99                   ),
//.i2c_addr_2byte                 (1'b1                     ),
//.lut_index                      (cmos2_lut_index          ),
//.lut_dev_addr                   (cmos2_lut_data[31:24]    ),
//.lut_reg_addr                   (cmos2_lut_data[23:8]     ),
//.lut_reg_data                   (cmos2_lut_data[7:0]      ),
//.error                          (                         ),
//.done                           (                         ),
//.i2c_scl                        (cmos2_scl                ),
//.i2c_sda                        (cmos2_sda                )
//);
/*************************************************************************
look-up table of camera coms2 
****************************************************************************/
//lut_ov5640_rgb565_1024_768 lut_ov5640_rgb565_1024_768_m1
//(
//.lut_index                      (cmos2_lut_index          ),
//.lut_data                       (cmos2_lut_data           )
//);
//wire                            cmos_pclk;
//wire                            cmos_vsync;
//wire                            cmos_href;
//wire [7:0]                      cmos_db;
/*************************************************************************
Select cmos1 or cmos2 with key2
****************************************************************************/
//cmos_select	cmos_select_inst
//(
//.clk                            (sys_clk                  ),
//.reset_n                        (rst_n                    ),	
//.key1                           (key2                     ),
//.cmos_pclk                      (cmos_pclk                ),
//.cmos_vsync                     (cmos_vsync               ),        
//.cmos_href                      (cmos_href                ),
//.cmos_d                         (cmos_db                  ),	

//.cmos1_pclk                     (cmos1_pclk               ),
//.cmos1_vsync                    (cmos1_vsync              ),        
//.cmos1_href                     (cmos1_href               ),
//.cmos1_d                        (cmos1_d                  ),
    
//.cmos2_pclk                     (cmos2_pclk               ),
//.cmos2_vsync                    (cmos2_vsync              ),		
//.cmos2_href                     (cmos2_href               ),
//.cmos2_d                        (cmos2_d                  )
//);
/*************************************************************************
CMOS sensor 8bit data is converted to 16bit data
****************************************************************************/ 
//cmos_8_16bit cmos_8_16bit_m0
//(
//.rst                            (~rst_n                   ),
//.pclk                           (cmos_pclk                ),
//.pdata_i                        (cmos_db                  ),
//.de_i                           (cmos_href                ),
//.pdata_o                        (cmos_16bit_data          ),
//.hblank                         (                         ),
//.de_o                           (cmos_16bit_wr            )
//);
//wire                i_pclk    ;
//wire                de      ;
//wire    [23:0]      pdata   ;
//wire                fv;
//wire                lv;
//wire                hs;
//wire                vs;
//wire                ready;
//assign              i_pclk = cmos_pclk;
//colorbar_gen #(
////1920x1080 @ 60fps @ 148.5MHz
//    .h_active      ('d1920 ),
//	.h_total       ('d2200 ),
//	.v_active      ('d1080 ),
//	.v_total       ('d1125 ),
//	.H_FRONT_PORCH ('d88   ),
//	.H_SYNCH       ('d44   ),
//	.H_BACK_PORCH  ('d148  ),
//	.V_FRONT_PORCH ('d4    ),
//	.V_SYNCH       ('d5    ),
//    .V_BACK_PORCH  ('d36   ),
//    .input_mode('d0),
//    .clk2_mode('d0),
//    .pattern_mode('d0)
//)u_colorbar_gen
//(
//	.rstn       (rst_n  ) , 
//	.clk        (cmos_pclk) ,
//	.data_i     (24'b0),
//	.fv         (fv) ,
//	.lv         (lv) ,
//	.data       (pdata),
//	.de         (de),
//	.vsync      (vs),
//	.hsync      (hs),
//	.ready      (ready)
//);

assign hdmi_tx_clk = hdmi_pclk;

//assign hdmi_tx_de  = de;
//assign hdmi_tx_vs  = vs;
//assign hdmi_tx_hs  = hs;
//assign hdmi_td     = pdata;

//assign write_en = de;
//assign write_data = {pdata[15:11],pdata[10:5],pdata[4:0]};
//assign write_data = {pdata[23:19],pdata[15:10],pdata[7:3]};
//assign write_data = {8'b0,pdata};

hdmi_i2c_cfg  inst_hdmi_i2c_cfg
(
  .clk (clk_50MHz),
  .rst (~rst_n),
  .scl (hdmi_scl),
  .sda (hdmi_sda)
); 

assign cmos1_rst_n = 1'b1;
//assign cmos2_rst_n = 1'b1;

wire            cmos1_cfg_done         ;
wire            cmos2_cfg_done         ;

cmos_cfg inst1_cmos_cfg (
    .clk      (clk_50MHz),
    .rst      (~rst_n),
    .scl      (cmos1_scl),
    .cfg_done (cmos1_cfg_done),
    .sda      (cmos1_sda)
);

//cmos_cfg inst2_cmos_cfg (
//    .clk      (clk_50MHz),
//    .rst      (~rst_n),
//    .scl      (cmos2_scl),
//    .cfg_done (cmos2_cfg_done),
//    .sda      (cmos2_sda)
//);

wire                    hs1;
wire                    hs2;
wire                    vs1;
wire                    vs2;
wire                    de1;
wire                    de2;

cmos_img_capture u1_cmos_img_capture
(
    .rst               (~rst_n),//复位信号
    .cmos_cfg_done     (cmos1_cfg_done),//寄存器配置完成信号 

    .cmos_pclk         (cmos1_pclk),//cmos 数据像素时钟
    .cmos_vsync        (cmos1_vsync),//cmos 场同步信号
    .cmos_href         (cmos1_href),//cmos 行同步信号
    .cmos_data         (cmos1_data[9:2]),//cmos 数据

    .cmos_hsync_d1     (hs1),
    .cmos_vsync_d1     (vs1),
    .cmos_data_wr      (ch0_write_data_r),
    .cmos_data_vld     (de1)
);

//cmos_img_capture u2_cmos_img_capture
//(
//    .rst               (~rst_n),//复位信号
//    .cmos_cfg_done     (cmos2_cfg_done),//寄存器配置完成信号 

//    .cmos_pclk         (cmos2_pclk),//cmos 数据像素时钟
//    .cmos_vsync        (cmos2_vsync),//cmos 场同步信号
//    .cmos_href         (cmos2_href),//cmos 行同步信号
//    .cmos_data         (cmos2_data[9:2]),//cmos 数据

//    .cmos_hsync_d1     (hs2),
//    .cmos_vsync_d1     (vs2),
//    .cmos_data_wr      (ch1_write_data_r),
//    .cmos_data_vld     (de2)
//);

video_rect_write_data
#(
.DATA_WIDTH     ('d32)
)
video_rect_write_data_m0
(
.video_clk                      (cmos1_pclk),          // Video pixel clock
.rst                            (~rst_n),
.video_left_offset              ('d50),
.video_top_offset               ('d100),
.video_width                    ('d400),
.video_height                   ('d400),
.write_req                      (ch0_write_req),           // Start reading a frame of data     
.write_req_ack                  (ch0_write_req_ack),       // Read request response
.write_addr_index               (ch0_write_addr_index),
.read_addr_index                (ch0_read_addr_index),
.write_en                       (ch0_write_en),            // Read data enable
//.write_data                     (write_data),          // Read data
.timing_hs                      (hs1),    
.timing_vs                      (vs1),    
.timing_de                      (de1),    
.timing_data                    (ch0_write_data_r), 
.hs                             (),                 // horizontal synchronization
.vs                             (),                 // vertical synchronization
.de                             (),                 // video valid
.vout_data                      (ch0_write_data)           // video data
);

//video_rect_write_data
//#(
//.DATA_WIDTH     ('d32)
//)
//video_rect_write_data_m1
//(
//.video_clk                      (cmos2_pclk),          // Video pixel clock
//.rst                            (~rst_n),
//.video_left_offset              ('d150),
//.video_top_offset               ('d100),
//.video_width                    ('d400),
//.video_height                   ('d400),
//.write_req                      (ch1_write_req),           // Start reading a frame of data     
//.write_req_ack                  (ch1_write_req_ack),       // Read request response
//.write_addr_index               (ch1_write_addr_index),
//.read_addr_index                (ch1_read_addr_index),
//.write_en                       (ch1_write_en),            // Read data enable
////.write_data                     (write_data),          // Read data
//.timing_hs                      (hs2),    
//.timing_vs                      (vs2),    
//.timing_de                      (de2),    
//.timing_data                    (ch1_write_data_r), 
//.hs                             (),                 // horizontal synchronization
//.vs                             (),                 // vertical synchronization
//.de                             (),                 // video valid
//.vout_data                      (ch1_write_data)           // video data
//);

/*************************************************************************
write bus arbitration
****************************************************************************/
mem_write_arbi
#(
.MEM_DATA_BITS                  (MEM_DATA_BITS            ),
.ADDR_BITS                      (ADDR_BITS                ),
.BUSRT_BITS                     (BUSRT_BITS               )
)
mem_write_arbi_m0
(
.rst_n                          (rst_n                    ),
.mem_clk                        (ui_clk                   ),

.ch0_wr_burst_req               (ch0_wr_burst_req         ),
.ch0_wr_burst_len               (ch0_wr_burst_len         ),
.ch0_wr_burst_addr              (ch0_wr_burst_addr        ),
.ch0_wr_burst_data_req          (ch0_wr_burst_data_req    ),
.ch0_wr_burst_data              (ch0_wr_burst_data        ),
.ch0_wr_burst_finish            (ch0_wr_burst_finish      ),

//.ch1_wr_burst_req               (ch1_wr_burst_req         ),
//.ch1_wr_burst_len               (ch1_wr_burst_len         ),
//.ch1_wr_burst_addr              (ch1_wr_burst_addr        ),
//.ch1_wr_burst_data_req          (ch1_wr_burst_data_req    ),
//.ch1_wr_burst_data              (ch1_wr_burst_data        ),
//.ch1_wr_burst_finish            (ch1_wr_burst_finish      ),

.wr_burst_req                   (wr_burst_req             ),
.wr_burst_len                   (wr_burst_len             ),
.wr_burst_addr                  (wr_burst_addr            ),
.wr_burst_data_req              (wr_burst_data_req        ),
.wr_burst_data                  (wr_burst_data            ),
.wr_burst_finish                (wr_burst_finish          )	
);

/*************************************************************************
CMOS sensor writes the request and generates the read and write address index
****************************************************************************/ 
//cmos_write_req_gen cmos_write_req_gen_m0
//(
//.rst                            (~rst_n                   ),
//.pclk                           (cmos_pclk                ),
//.cmos_vsync                     (vs                       ),
//.write_req                      (write_req                ),
//.write_addr_index               (write_addr_index         ),
//.read_addr_index                (read_addr_index          ),
//.write_req_ack                  (write_req_ack            )
//);


wire    v0_fv;
wire    v0_lv;
wire    v0_de;
wire    v0_vs;
wire    v0_hs;

timing_gen #(
//1920x1080 @ 60fps @ 148.5MHz
    .h_active      ('d1920 ),
	.h_total       ('d2200 ),
	.v_active      ('d1080 ),
	.v_total       ('d1125 ),
	.H_FRONT_PORCH ('d88   ),
	.H_SYNCH       ('d44   ),
	.H_BACK_PORCH  ('d148  ),
	.V_FRONT_PORCH ('d4    ),
	.V_SYNCH       ('d5    ),
    .V_BACK_PORCH  ('d36   )
)u_timming_gen
(
	.rst_n      (rst_n  ) , 
	.clk        (hdmi_pclk) ,
	.fv         (v0_fv) ,
	.lv         (v0_lv) ,
	.de         (v0_de),
	.vsync      (v0_vs),
	.hsync      (v0_hs)
);
/*************************************************************************
The video output timing generator and generate a frame read data request
****************************************************************************/ 
wire[32:0]                       vout_data;              //video data

wire    v1_fv;
wire    v1_lv;
wire    v1_de;
wire    v1_vs;
wire    v1_hs;
wire[32:0]                       v1_data;

video_rect_read_data #
(
.DATA_WIDTH                     ('d32)
)video_rect_read_data_m0
(
.video_clk                      (hdmi_pclk                ),
.rst                            (~rst_n                   ),
.video_left_offset              (12'd760                  ),
.video_top_offset               (12'd340                  ),
.video_width                    (12'd400                  ),
.video_height                   (12'd400                  ),
.read_req                       (ch0_read_req                 ),
.read_req_ack                   (ch0_read_req_ack             ),
.read_en                        (ch0_read_en                  ),
.read_data                      (ch0_read_data                ),
.timing_hs                      (v0_hs                    ),
.timing_vs                      (v0_vs                    ),
.timing_de                      (v0_de                    ),
.timing_data                    (32'd0                    ),
.hs                             (v1_hs               ),
.vs                             (v1_vs               ),
.de                             (v1_de               ),
.vout_data                      (v1_data                )
);

video_rect_read_data #
(
.DATA_WIDTH                     ('d32)
)video_rect_read_data_m1
(
.video_clk                      (hdmi_pclk                ),
.rst                            (~rst_n                   ),
.video_left_offset              (12'd160                  ),
.video_top_offset               (12'd140                  ),
.video_width                    (12'd400                  ),
.video_height                   (12'd400                  ),
.read_req                       (ch1_read_req                 ),
.read_req_ack                   (ch1_read_req_ack             ),
.read_en                        (ch1_read_en                  ),
.read_data                      (ch1_read_data                ),
.timing_hs                      (v1_hs                    ),
.timing_vs                      (v1_vs                    ),
.timing_de                      (v1_de                    ),
.timing_data                    (v1_data                    ),
.hs                             (hdmi_tx_hs               ),
.vs                             (hdmi_tx_vs               ),
.de                             (hdmi_tx_de               ),
.vout_data                      (vout_data                )
);

assign hdmi_td = vout_data[23:0];
//assign hdmi_td = {{vout_data[15:11],3'd0},{vout_data[10:5],2'd0}, {vout_data[4:0],3'd0} } ;


/*************************************************************************
read us arbitration
****************************************************************************/
mem_read_arbi 
#(
.MEM_DATA_BITS                  (MEM_DATA_BITS            ),
.ADDR_BITS                      (ADDR_BITS                ),
.BUSRT_BITS                     (BUSRT_BITS               )
)
mem_read_arbi_m0
(
.rst_n                          (rst_n                    ),
.mem_clk                        (ui_clk                   ),
.ch0_rd_burst_req               (ch0_rd_burst_req         ),
.ch0_rd_burst_len               (ch0_rd_burst_len         ),
.ch0_rd_burst_addr              (ch0_rd_burst_addr        ),
.ch0_rd_burst_data_valid        (ch0_rd_burst_data_valid  ),
.ch0_rd_burst_data              (ch0_rd_burst_data        ),
.ch0_rd_burst_finish            (ch0_rd_burst_finish      ),

.ch1_rd_burst_req               (ch1_rd_burst_req         ),
.ch1_rd_burst_len               (ch1_rd_burst_len         ),
.ch1_rd_burst_addr              (ch1_rd_burst_addr        ),
.ch1_rd_burst_data_valid        (ch1_rd_burst_data_valid  ),
.ch1_rd_burst_data              (ch1_rd_burst_data        ),
.ch1_rd_burst_finish            (ch1_rd_burst_finish      ),

.rd_burst_req                   (rd_burst_req             ),
.rd_burst_len                   (rd_burst_len             ),
.rd_burst_addr                  (rd_burst_addr            ),
.rd_burst_data_valid            (rd_burst_data_valid      ),
.rd_burst_data                  (rd_burst_data            ),
.rd_burst_finish                (rd_burst_finish          )	
);

/*************************************************************************
Convert video data to YCBCR
****************************************************************************/ 
//rgb_to_ycbcr rgb_to_ycbcr_m0
//(
//.clk                            (video_clk                ),
//.rst                            (~rst_n                   ),
//.rgb_r                          ({vout_data[15:11],3'd0}  ),
//.rgb_g                          ({vout_data[10:5],2'd0}   ),
//.rgb_b                          ({vout_data[4:0],3'd0}    ),
//.rgb_hs                         (hs                       ),
//.rgb_vs                         (vs                       ),
//.rgb_de                         (de                       ),
//.ycbcr_y                        (ycbcr_y                  ),
//.ycbcr_cb                       (                         ),
//.ycbcr_cr                       (                         ),
//.ycbcr_hs                       (ycbcr_hs                 ),
//.ycbcr_vs                       (ycbcr_vs                 ),
//.ycbcr_de                       (ycbcr_de                 )
//);
/*************************************************************************
YCBCR to sobel algorithm
****************************************************************************/ 
//sobel sobel_m0
//(
//.rst                            (~rst_n                   ),
//.pclk                           (video_clk                ),
//.threshold                      (8'd40                    ),
//.ycbcr_hs                       (ycbcr_hs                 ),
//.ycbcr_vs                       (ycbcr_vs                 ),
//.ycbcr_de                       (ycbcr_de                 ),
//.data_in                        (ycbcr_y                  ),
//.data_out                       (sobel_out                ),
//.sobel_hs                       (sobel_hs                 ),
//.sobel_vs                       (sobel_vs                 ),
//.sobel_de                       (sobel_de                 )
//);
/*************************************************************************
RGB to DVI conversion module
****************************************************************************/
//rgb2dvi
//#(
//.kGenerateSerialClk             (1'b0                     ),
//.kClkRange                      (1                        ),     
//.kRstActiveHigh                 (1'b1                     )
//)
//rgb2dvi_m0 
//(
//// DVI 1.0 TMDS video interface
//.TMDS_Clk_p                     (tmds_clk_p               ),
//.TMDS_Clk_n                     (tmds_clk_n               ),
//.TMDS_Data_p                    (tmds_data_p              ),
//.TMDS_Data_n                    (tmds_data_n              ),
////Auxiliary signals 
//.aRst                           (1'b0                     ),        //asynchronous reset; must be reset when RefClk is not within spec
//.aRst_n                         (1'b1                     ),        //-asynchronous reset; must be reset when RefClk is not within spec
//// Video in
//.vid_pData                      ({hdmi_r,hdmi_b,hdmi_g}   ),
//.vid_pVDE                       (hdmi_de                  ),
//.vid_pHSync                     (hdmi_hs                  ),
//.vid_pVSync                     (hdmi_vs                  ),
//.PixelClk                       (video_clk                ),

//.SerialClk                      (video_clk5x              )         // 5x PixelClk
//); 
/*************************************************************************
video frame data read-write control
/****************************************************************************/
frame_read frame_read_m0
(
.rst                            (~rst_n                    ),
.mem_clk                        (ui_clk                    ),

.rd_burst_req                   (ch0_rd_burst_req              ),
.rd_burst_len                   (ch0_rd_burst_len              ),
.rd_burst_addr                  (ch0_rd_burst_addr             ),
.rd_burst_data_valid            (ch0_rd_burst_data_valid       ),
.rd_burst_data                  (ch0_rd_burst_data             ),
.rd_burst_finish                (ch0_rd_burst_finish           ),
.read_clk                       (hdmi_pclk                 ),
.read_req                       (ch0_read_req                  ),
.read_req_ack                   (ch0_read_req_ack              ),
.read_finish                    (                          ),
.read_addr_0                    (26'd0                     ), //The first frame address is 0
.read_addr_1                    (26'd8294400               ), //The second frame address is 24'd2073600 ,large enough address space for one frame of video
.read_addr_2                    (26'd8294400*2             ),
.read_addr_3                    (26'd8294400*3             ),
//.read_addr_0                    (24'd0                     ), //The first frame address is 0
//.read_addr_1                    (24'd2073600               ),
//.read_addr_2                    (24'd4147200               ),
//.read_addr_3                    (24'd6220800               ),
.read_addr_index                (ch0_read_addr_index           ),
//.read_len                       (24'd196608                ),//frame size 1024 * 768 * 16 / 64
//.read_len                       (24'd393216                ),//frame size 1024 * 768 * 32 / 64
//.read_len                       (26'd518400                ),//frame size 1920 * 1080 * 16 / 64
.read_len                       (26'd40000                ),//frame size 400 * 400 * 32 / 128
.read_en                        (ch0_read_en                   ),
.read_data                      (ch0_read_data                 )
);

/*************************************************************************
video frame data read-write control
/****************************************************************************/
frame_read frame_read_m1
(
.rst                            (~rst_n                    ),
.mem_clk                        (ui_clk                    ),

.rd_burst_req                   (ch1_rd_burst_req              ),
.rd_burst_len                   (ch1_rd_burst_len              ),
.rd_burst_addr                  (ch1_rd_burst_addr             ),
.rd_burst_data_valid            (ch1_rd_burst_data_valid       ),
.rd_burst_data                  (ch1_rd_burst_data             ),
.rd_burst_finish                (ch1_rd_burst_finish           ),
.read_clk                       (hdmi_pclk                 ),
.read_req                       (ch1_read_req                  ),
.read_req_ack                   (ch1_read_req_ack              ),
.read_finish                    (                          ),
//.read_addr_0                    (26'd8294400*4                     ), //The first frame address is 0
//.read_addr_1                    (26'd8294400*5               ), //The second frame address is 24'd2073600 ,large enough address space for one frame of video
//.read_addr_2                    (26'd8294400*6             ),
//.read_addr_3                    (26'd8294400*7             ),

.read_addr_0                    (26'd0                     ), //The first frame address is 0
.read_addr_1                    (26'd8294400               ), //The second frame address is 24'd2073600 ,large enough address space for one frame of video
.read_addr_2                    (26'd8294400*2             ),
.read_addr_3                    (26'd8294400*3             ),
//.read_addr_0                    (24'd0                     ), //The first frame address is 0
//.read_addr_1                    (24'd2073600               ),
//.read_addr_2                    (24'd4147200               ),
//.read_addr_3                    (24'd6220800               ),
//.read_addr_index                (ch1_read_addr_index           ),
.read_addr_index                (ch0_read_addr_index           ),

//.read_len                       (24'd196608                ),//frame size 1024 * 768 * 16 / 64
//.read_len                       (24'd393216                ),//frame size 1024 * 768 * 32 / 64
//.read_len                       (26'd518400                ),//frame size 1920 * 1080 * 16 / 64
.read_len                       (26'd40000                ),//frame size 400 * 400 * 32 / 128
.read_en                        (ch1_read_en                   ),
.read_data                      (ch1_read_data                 )
);

frame_write frame_write_m0
(
.rst                            (~rst_n                    ),
.mem_clk                        (ui_clk                    ),
.wr_burst_req                   (ch0_wr_burst_req              ),
.wr_burst_len                   (ch0_wr_burst_len              ),
.wr_burst_addr                  (ch0_wr_burst_addr             ),
.wr_burst_data_req              (ch0_wr_burst_data_req         ),
.wr_burst_data                  (ch0_wr_burst_data             ),
.wr_burst_finish                (ch0_wr_burst_finish           ),
.write_clk                      (cmos1_pclk                 ),
.write_req                      (ch0_write_req                 ),
.write_req_ack                  (ch0_write_req_ack             ),
.write_finish                   (                          ),
//.write_addr_0                   (24'd0                     ),
//.write_addr_1                   (24'd2073600               ),
//.write_addr_2                   (24'd4147200               ),
//.write_addr_3                   (24'd6220800               ),
.write_addr_0                   (26'd0                     ),
.write_addr_1                   (26'd8294400               ),
.write_addr_2                   (26'd8294400*2             ),
.write_addr_3                   (26'd8294400*3             ),
.write_addr_index               (ch0_write_addr_index          ),
//.write_len                      (24'd196608                ),//frame size 1024 * 768 * 16 / 64
//.write_len                      (24'd393216                ),//frame size 1024 * 768 * 32 / 64
.write_len                      (26'd40000                ),//frame size 400 * 400 * 32 / 128
.write_en                       (ch0_write_en                  ),
.write_data                     (ch0_write_data                )
);

//frame_write frame_write_m1
//(
//.rst                            (~rst_n                    ),
//.mem_clk                        (ui_clk                    ),
//.wr_burst_req                   (ch1_wr_burst_req              ),
//.wr_burst_len                   (ch1_wr_burst_len              ),
//.wr_burst_addr                  (ch1_wr_burst_addr             ),
//.wr_burst_data_req              (ch1_wr_burst_data_req         ),
//.wr_burst_data                  (ch1_wr_burst_data             ),
//.wr_burst_finish                (ch1_wr_burst_finish           ),
//.write_clk                      (cmos2_pclk                 ),
//.write_req                      (ch1_write_req                 ),
//.write_req_ack                  (ch1_write_req_ack             ),
//.write_finish                   (                          ),
////.write_addr_0                   (24'd0                     ),
////.write_addr_1                   (24'd2073600               ),
////.write_addr_2                   (24'd4147200               ),
////.write_addr_3                   (24'd6220800               ),
//.write_addr_0                   (26'd8294400*4                     ),
//.write_addr_1                   (26'd8294400*5             ),
//.write_addr_2                   (26'd8294400*6             ),
//.write_addr_3                   (26'd8294400*7             ),
//.write_addr_index               (ch1_write_addr_index          ),
////.write_len                      (24'd196608                ),//frame size 1024 * 768 * 16 / 64
////.write_len                      (24'd393216                ),//frame size 1024 * 768 * 32 / 64
//.write_len                      (26'd40000                ),//frame size 400 * 400 * 32 / 128
//.write_en                       (ch1_write_en                  ),
//.write_data                     (ch1_write_data                )
//);



/*************************************************************************
XILINX MIG IP with AXI bus
****************************************************************************/
//ddr3 u_ddr3 
//(
//// Memory interface ports
//.ddr3_addr                      (ddr3_addr                 ), 
//.ddr3_ba                        (ddr3_ba                   ), 
//.ddr3_cas_n                     (ddr3_cas_n                ), 
//.ddr3_ck_n                      (ddr3_ck_n                 ), 
//.ddr3_ck_p                      (ddr3_ck_p                 ),
//.ddr3_cke                       (ddr3_cke                  ),  
//.ddr3_ras_n                     (ddr3_ras_n                ), 
//.ddr3_reset_n                   (ddr3_reset_n              ), 
//.ddr3_we_n                      (ddr3_we_n                 ),  
//.ddr3_dq                        (ddr3_dq                   ),  
//.ddr3_dqs_n                     (ddr3_dqs_n                ),  
//.ddr3_dqs_p                     (ddr3_dqs_p                ),  
//.init_calib_complete            (init_calib_complete       ),  
 
//.ddr3_cs_n                      (ddr3_cs_n                 ),  
//.ddr3_dm                        (ddr3_dm                   ),  
//.ddr3_odt                       (ddr3_odt                  ),  
//// Application interface ports
//.ui_clk                         (ui_clk                    ), 
//.ui_clk_sync_rst                (ui_clk_sync_rst           ),  // output	   ui_clk_sync_rst
//.mmcm_locked                    (                          ),  // output	    mmcm_locked
//.aresetn                        (1'b1                      ),  // input			aresetn
//.app_sr_req                     (1'b0                      ),  // input			app_sr_req
//.app_ref_req                    (1'b0                      ),  // input			app_ref_req
//.app_zq_req                     (1'b0                      ),  // input			app_zq_req
//.app_sr_active                  (                          ),  // output	    app_sr_active
//.app_ref_ack                    (                          ),  // output		app_ref_ack
//.app_zq_ack                     (                          ),  // output		app_zq_ack
//// Slave Interface Write Address Ports
//.s_axi_awid                     (s00_axi_awid              ),  // input [0:0]	s_axi_awid
//.s_axi_awaddr                   (s00_axi_awaddr            ),  // input [29:0]	s_axi_awaddr
//.s_axi_awlen                    (s00_axi_awlen             ),  // input [7:0]	s_axi_awlen
//.s_axi_awsize                   (s00_axi_awsize            ),  // input [2:0]	s_axi_awsize
//.s_axi_awburst                  (s00_axi_awburst           ),  // input [1:0]	s_axi_awburst
//.s_axi_awlock                   (s00_axi_awlock            ),  // input [0:0]	s_axi_awlock
//.s_axi_awcache                  (s00_axi_awcache           ),  // input [3:0]	s_axi_awcache
//.s_axi_awprot                   (s00_axi_awprot            ),  // input [2:0]	s_axi_awprot
//.s_axi_awqos                    (s00_axi_awqos             ),  // input [3:0]	s_axi_awqos
//.s_axi_awvalid                  (s00_axi_awvalid           ),  // input			s_axi_awvalid
//.s_axi_awready                  (s00_axi_awready           ),  // output	    s_axi_awready
//// Slave Interface Write Data Ports
//.s_axi_wdata                    (s00_axi_wdata             ),  // input [63:0]	s_axi_wdata
//.s_axi_wstrb                    (s00_axi_wstrb             ),  // input [7:0]	s_axi_wstrb
//.s_axi_wlast                    (s00_axi_wlast             ),  // input			s_axi_wlast
//.s_axi_wvalid                   (s00_axi_wvalid            ),  // input			s_axi_wvalid
//.s_axi_wready                   (s00_axi_wready            ),  // output		s_axi_wready
//// Slave Interface Write Response Ports
//.s_axi_bid                      (s00_axi_bid               ),  // output [0:0]	s_axi_bid
//.s_axi_bresp                    (s00_axi_bresp             ),  // output [1:0]	s_axi_bresp
//.s_axi_bvalid                   (s00_axi_bvalid            ),  // output		s_axi_bvalid
//.s_axi_bready                   (s00_axi_bready            ),  // input			s_axi_bready
//// Slave Interface Read Address Ports
//.s_axi_arid                     (s00_axi_arid              ),  // input [0:0]	s_axi_arid
//.s_axi_araddr                   (s00_axi_araddr            ),  // input [29:0]	s_axi_araddr
//.s_axi_arlen                    (s00_axi_arlen             ),  // input [7:0]	s_axi_arlen
//.s_axi_arsize                   (s00_axi_arsize            ),  // input [2:0]	s_axi_arsize
//.s_axi_arburst                  (s00_axi_arburst           ),  // input [1:0]	s_axi_arburst
//.s_axi_arlock                   (s00_axi_arlock            ),  // input [0:0]	s_axi_arlock
//.s_axi_arcache                  (s00_axi_arcache           ),  // input [3:0]	s_axi_arcache
//.s_axi_arprot                   (s00_axi_arprot            ),  // input [2:0]	s_axi_arprot
//.s_axi_arqos                    (s00_axi_arqos             ),  // input [3:0]	s_axi_arqos
//.s_axi_arvalid                  (s00_axi_arvalid           ),  // input			s_axi_arvalid
//.s_axi_arready                  (s00_axi_arready           ),  // output		s_axi_arready
//// Slave Interface Read Data Ports
//.s_axi_rid                      (s00_axi_rid               ),  // output [0:0]	s_axi_rid
//.s_axi_rdata                    (s00_axi_rdata             ),  // output [63:0]	s_axi_rdata
//.s_axi_rresp                    (s00_axi_rresp             ),  // output [1:0]	s_axi_rresp
//.s_axi_rlast                    (s00_axi_rlast             ),  // output	    s_axi_rlast
//.s_axi_rvalid                   (s00_axi_rvalid            ),  // output		s_axi_rvalid
//.s_axi_rready                   (s00_axi_rready            ),  // input			s_axi_rready
//// System Clock Ports
//.sys_clk_i                      (clk_200MHz                ),  //               MIG clock
//.sys_rst                        (rst_n                     )   //              input sys_rst
//);
ddr3 u_ddr3
(
// Memory interface ports
.ddr3_addr                      (ddr3_addr              ),
.ddr3_ba                        (ddr3_ba                ),
.ddr3_cas_n                     (ddr3_cas_n             ),
.ddr3_ck_n                      (ddr3_ck_n              ),
.ddr3_ck_p                      (ddr3_ck_p              ),
.ddr3_cke                       (ddr3_cke               ),
.ddr3_ras_n                     (ddr3_ras_n             ),
.ddr3_reset_n                   (ddr3_reset_n           ),
.ddr3_we_n                      (ddr3_we_n              ),
.ddr3_dq                        (ddr3_dq                ),
.ddr3_dqs_n                     (ddr3_dqs_n             ),
.ddr3_dqs_p                     (ddr3_dqs_p             ),
.init_calib_complete            (init_calib_complete    ),
.ddr3_cs_n                      (ddr3_cs_n              ),
.ddr3_dm                        (ddr3_dm                ),
.ddr3_odt                       (ddr3_odt               ),
// Application interface ports
.app_addr                       (app_addr               ),
.app_cmd                        (app_cmd                ),
.app_en                         (app_en                 ),
.app_wdf_data                   (app_wdf_data           ),
.app_wdf_end                    (app_wdf_end            ),
.app_wdf_wren                   (app_wdf_wren           ),
.app_rd_data                    (app_rd_data            ),
.app_rd_data_end                (app_rd_data_end        ),
.app_rd_data_valid              (app_rd_data_valid      ),
.app_rdy                        (app_rdy                ),
.app_wdf_rdy                    (app_wdf_rdy            ),
.app_sr_req                     (1'b0                   ),
.app_ref_req                    (1'b0                   ),
.app_zq_req                     (1'b0                   ),
.app_sr_active                  (app_sr_active          ),
.app_ref_ack                    (app_ref_ack            ),
.app_zq_ack                     (app_zq_ack             ),
.ui_clk                         (ui_clk                 ),
.ui_clk_sync_rst                (ui_clk_sync_rst        ),

.app_wdf_mask                   (app_wdf_mask           ),

.sys_clk_i                      (clk_200MHz         ),      // System Clock Ports    
.sys_rst                        (rst_n                  )
);
/*************************************************************************
AXI User Interface Conversion 
****************************************************************************/
//aq_axi_master u_aq_axi_master
//(
//.ARESETN                        (~ui_clk_sync_rst         ),
//.ACLK                           (ui_clk                   ),
//.M_AXI_AWID                     (s00_axi_awid             ),
//.M_AXI_AWADDR                   (s00_axi_awaddr           ),
//.M_AXI_AWLEN                    (s00_axi_awlen            ),
//.M_AXI_AWSIZE                   (s00_axi_awsize           ),
//.M_AXI_AWBURST                  (s00_axi_awburst          ),
//.M_AXI_AWLOCK                   (s00_axi_awlock           ),
//.M_AXI_AWCACHE                  (s00_axi_awcache          ),
//.M_AXI_AWPROT                   (s00_axi_awprot           ),
//.M_AXI_AWQOS                    (s00_axi_awqos            ),
//.M_AXI_AWUSER                   (s00_axi_awuser           ),
//.M_AXI_AWVALID                  (s00_axi_awvalid          ),
//.M_AXI_AWREADY                  (s00_axi_awready          ),
//.M_AXI_WDATA                    (s00_axi_wdata            ),
//.M_AXI_WSTRB                    (s00_axi_wstrb            ),
//.M_AXI_WLAST                    (s00_axi_wlast            ),
//.M_AXI_WUSER                    (s00_axi_wuser            ),
//.M_AXI_WVALID                   (s00_axi_wvalid           ),
//.M_AXI_WREADY                   (s00_axi_wready           ),
//.M_AXI_BID                      (s00_axi_bid              ),
//.M_AXI_BRESP                    (s00_axi_bresp            ),
//.M_AXI_BUSER                    (s00_axi_buser            ),
//.M_AXI_BVALID                   (s00_axi_bvalid           ),
//.M_AXI_BREADY                   (s00_axi_bready           ),
//.M_AXI_ARID                     (s00_axi_arid             ),
//.M_AXI_ARADDR                   (s00_axi_araddr           ),
//.M_AXI_ARLEN                    (s00_axi_arlen            ),
//.M_AXI_ARSIZE                   (s00_axi_arsize           ),
//.M_AXI_ARBURST                  (s00_axi_arburst          ),
//.M_AXI_ARLOCK                   (s00_axi_arlock           ),
//.M_AXI_ARCACHE                  (s00_axi_arcache          ),
//.M_AXI_ARPROT                   (s00_axi_arprot           ),
//.M_AXI_ARQOS                    (s00_axi_arqos            ),
//.M_AXI_ARUSER                   (s00_axi_aruser           ),
//.M_AXI_ARVALID                  (s00_axi_arvalid          ),
//.M_AXI_ARREADY                  (s00_axi_arready          ),
//.M_AXI_RID                      (s00_axi_rid              ),
//.M_AXI_RDATA                    (s00_axi_rdata            ),
//.M_AXI_RRESP                    (s00_axi_rresp            ),
//.M_AXI_RLAST                    (s00_axi_rlast            ),
//.M_AXI_RUSER                    (s00_axi_ruser            ),
//.M_AXI_RVALID                   (s00_axi_rvalid           ),
//.M_AXI_RREADY                   (s00_axi_rready           ),
//.MASTER_RST                     (1'b0                     ),
//.WR_START                       (wr_burst_req             ),
//.WR_ADRS                        ({wr_burst_addr,3'd0}     ),
//.WR_LEN                         ({wr_burst_len,3'd0}      ),
//.WR_READY                       (                         ),
//.WR_FIFO_RE                     (wr_burst_data_req        ),
//.WR_FIFO_EMPTY                  (1'b0                     ),
//.WR_FIFO_AEMPTY                 (1'b0                     ),
//.WR_FIFO_DATA                   (wr_burst_data            ),
//.WR_DONE                        (wr_burst_finish          ),
//.RD_START                       (rd_burst_req             ),
//.RD_ADRS                        ({rd_burst_addr,3'd0}     ),
//.RD_LEN                         ({rd_burst_len,3'd0}      ),
//.RD_READY                       (                         ),
//.RD_FIFO_WE                     (rd_burst_data_valid      ),
//.RD_FIFO_FULL                   (1'b0                     ),
//.RD_FIFO_AFULL                  (1'b0                     ),
//.RD_FIFO_DATA                   (rd_burst_data            ),
//.RD_DONE                        (rd_burst_finish          ),
//.DEBUG                          (                         )
//);

//实例化mem_burst
mem_burst
#(
	.MEM_DATA_BITS(MEM_DATA_BITS),
	.ADDR_BITS(ADDR_BITS)
)
 mem_burst_m0
(
   .rst(ui_clk_sync_rst),                      /*复位*/
   .mem_clk(ui_clk),                           /*接口时钟*/
   .rd_burst_req(rd_burst_req),                /*DDR Burst读请求*/
   .wr_burst_req(wr_burst_req),                /*DDR Burst写请求*/
   .rd_burst_len(rd_burst_len),                /*DDR Burst读数据长度*/
   .wr_burst_len(wr_burst_len),                 /*DDR Burst写数据长度*/
   .rd_burst_addr(rd_burst_addr),               /*DDR Burst读首地址*/
   .wr_burst_addr(wr_burst_addr),               /*DDR Burst写首地址*/
   .rd_burst_data_valid(rd_burst_data_valid),   /*DDR Burst读出数据有效*/
   .wr_burst_data_req(wr_burst_data_req),       /*DDR Burst写数据信号*/
   .rd_burst_data(rd_burst_data),               /*DDR Burst读出的数据*/
   .wr_burst_data(wr_burst_data),               /*DDR Burst写入的数据*/
   .rd_burst_finish(rd_burst_finish),           /*DDR Burst读完成*/
   .wr_burst_finish(wr_burst_finish),           /*DDR Burst写完成*/
   .burst_finish(),                             /*读或写完成*/
   
   ///////////////////
  .app_addr(app_addr),
  .app_cmd(app_cmd),
  .app_en(app_en),
  .app_wdf_data(app_wdf_data),
  .app_wdf_end(app_wdf_end),
  .app_wdf_mask(app_wdf_mask),
  .app_wdf_wren(app_wdf_wren),
  .app_rd_data(app_rd_data),
  .app_rd_data_end(app_rd_data_end),
  .app_rd_data_valid(app_rd_data_valid),
  .app_rdy(app_rdy),
  .app_wdf_rdy(app_wdf_rdy),
  .ui_clk_sync_rst(),  
  .init_calib_complete(init_calib_complete)
);

endmodule