//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//  Author: meisq                                                               //
//          msq@qq.com                                                          //
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
//  2017/7/19     meisq          1.0         Original
//*******************************************************************************/

module video_timing_data
#(
	parameter DATA_WIDTH = 16            ,           // Video data one clock data width
	
	// 1920x1080 @ 60fps @ 148.5MHz
    parameter h_active      = 'd1920     , 
    parameter h_total       = 'd2200     ,
    parameter v_active      = 'd1080     ,
    parameter v_total       = 'd1125     ,
    parameter H_FRONT_PORCH = 'd88       ,
    parameter H_SYNCH       = 'd44       ,
    parameter H_BACK_PORCH  = 'd148      ,
    parameter V_FRONT_PORCH = 'd4        ,
    parameter V_SYNCH       = 'd5        ,
    parameter V_BACK_PORCH  = 'd36       
)
(
	input                       clk,                // Video pixel clock
	input                       rst_n,
	output reg                  read_req,           // Start reading a frame of data     
	input                       read_req_ack,       // Read request response
	output reg                  read_en,            // Read data enable
	input[DATA_WIDTH - 1:0]     read_data,          // Read data
	output                      lv,                 // line valid
	output                      fv,                 // frame valid
	output                      hs,                 // horizontal synchronization
	output                      vs,                 // vertical synchronization
	output                      de,                 // video valid
	output[DATA_WIDTH - 1:0]    vout_data,           // video data
	output [11:0]               line_cnt,
	output [11:0]               col_cnt
);

//parameter TOP = 'd340 ; //边界：上
//parameter BOTTOM = 'd740 ; //边界：下
//parameter LEFT = 'd760 ; //边界：左
//parameter RIGHT = 'd1160 ; //边界：右

parameter TOP = 11'd0 ; //边界：上
parameter BOTTOM = 11'd1080 ; //边界：下
parameter LEFT = 11'd0 ; //边界：左
parameter RIGHT = 11'd1920 ; //边界：右



reg                    lv_r;
reg                    fv_r;
reg                    hs_r;
reg                    vs_r;
reg                    de_r;
//delay 1 clock cycle
reg                    lv_d0;
reg                    fv_d0;
reg                    hs_d0;
reg                    vs_d0;
reg                    de_d0;
//delay 2 clock cycles
reg                    lv_d1;
reg                    fv_d1;
reg                    hs_d1;
reg                    vs_d1;
reg                    de_d1;

reg[DATA_WIDTH - 1:0]  vout_data_r;
//assign read_en = video_de;
assign lv = lv_d1;
assign fv = fv_d1;
assign hs = hs_d1;
assign vs = vs_d1;
assign de = de_d1;
assign vout_data = vout_data_r;
always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
	    lv_d0 <= 1'b0;
	    fv_d0 <= 1'b0;
		hs_d0 <= 1'b0;
		vs_d0 <= 1'b0;
		de_d0 <= 1'b0;
	end
	else
	begin
	    //delay video_hs video_vs  video_de  clock cycle
	    lv_d0 <= lv_r;
	    fv_d0 <= fv_r;
	    hs_d0 <= hs_r;
		vs_d0 <= vs_r;
		de_d0 <= de_r;
		//delay video_hs video_vs  video_de 2 clock cycles
		lv_d1 <= lv_d0;
		fv_d1 <= fv_d0;
		hs_d1 <= hs_d0;
		vs_d1 <= vs_d0;
		de_d1 <= de_d0;		
	end
end

//always@(posedge clk or negedge rst_n)
//begin
//	if(rst == 1'b0)
//		vout_data_r <= {DATA_WIDTH{1'b0}};
//	else if(video_de_d0)
//		vout_data_r <= read_data;
//	else
//		vout_data_r <= {DATA_WIDTH{1'b0}};
//end
reg [11:0] ative_line_cnt;
always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		read_req <= 1'b0;
	else if(hs_d0 & ~hs_r) //vertical synchronization edge (the rising or falling edges are OK)
	    read_req <= 1'b1;
	else if(read_req_ack)
		read_req <= 1'b0;
end

reg [11:0] pixcnt; 
reg [11:0] linecnt;
reg [10:0] fv_cnt;
reg [11:0] color_cntr;	
reg        q_fv;
reg [7:0]  rstn_cnt;


assign line_cnt=((ative_line_cnt>=200) && (ative_line_cnt< 600 )) ? ative_line_cnt - 200: 0;
//assign line_cnt=0;
assign col_cnt=color_cntr;

// count rstn hi every posedge clk, until rstn == 128
// it means rstn keeping hi for 128 clks
always @(posedge clk or negedge rst_n) 
if (!rst_n) 
	 rstn_cnt <= 0;
else
	 rstn_cnt <= rstn_cnt[7] ? rstn_cnt : rstn_cnt+1;
		 

always @(posedge clk or negedge rstn_cnt[7]) 
begin 
    // when rstn keeping hi less than 128 clks
	// reset these values
    if (!rstn_cnt[7]) 
    begin 
		fv_cnt    <= 0;  
		pixcnt    <= 12'd0; 

		linecnt   <= 12'd0;

		lv_r      <= 1'b0;  
		fv_r      <= 1'b0;  
		q_fv      <= 0;                                    

		hs_r      <= 0;
		vs_r      <= 0;         
    end
	// when rstn keeping hi more than 128 clks
    else 
	begin 
		// frame valid counter, 
		// if fv_cnt less than 'd2047, add 1 when fv=0, q_fv=1
		// else fv_cnt keeping 'd2047
		// 
		// equal to 
		// if ( fv=0 and q_fv=1), then 
		//   if (fv_cnt < 'd2047) then fv_cnt <= fv_cnt+1
		//   else fv_cnt <= fv_cnt
		//
		// tip:
		// if fv=1,q_fv=0, then ~fv&q_fv=0
		// if fv=1,q_fv=1, then ~fv&q_fv=0
		// if fv=0,q_fv=0, then ~fv&q_fv=0
		// if fv=0,q_fv=1, then ~fv&q_fv=1
		fv_cnt    <= (fv_cnt==11'h7FF)  ? 11'h7FF  : fv_cnt+ (~fv&q_fv);
		
		// pixel counter in one line, 
		// if pixcnt less than h_total, then pixcnt add 1
		// else pixcnt <= 0
		pixcnt    <= (pixcnt<h_total-1) ? pixcnt+1 : 0;  
		
		// line counter in one frame,	
		// if pixcnt == h_total-1, then
		//   if linecnt< v_total-1, then linecnt <= linecnt+1
		//   else if linecnt==v_total-1, then linecnt <= 0
		// else pixcnt < h_total-1, then linecnt <= linecnt
		linecnt   <= (linecnt==v_total-1 && pixcnt ==h_total-1)  ? 0         :  
				   (linecnt< v_total-1 && pixcnt ==h_total-1)  ? linecnt+1 : linecnt; 
		
        // line valid,
		// linecnt between 1 and v_active
		// pixcnt between 1 and h_active
		lv_r        <= (pixcnt>12'd0)   & (pixcnt<=h_active) & (linecnt> 0 & linecnt<=v_active); 
		
		// frame valid, 
		// linecnt between 0 and v_active+1
		fv_r        <= (linecnt>=12'd0) & (linecnt<=v_active+1);
		
		// prev fv, frame valid value in last clk
		q_fv      <= fv_r; 
		
		
		de_r        <= (pixcnt > 12'd0) & (pixcnt <= h_active) & ((linecnt > 0) & (linecnt <= v_active));

		// 
		hs_r     <= (pixcnt>h_active+H_FRONT_PORCH)   & (pixcnt<=h_active+H_FRONT_PORCH+H_SYNCH); 
		
		// 
		vs_r     <= (linecnt>=v_active+V_FRONT_PORCH) & (linecnt<v_active+V_FRONT_PORCH+V_SYNCH);       	   
    end 
end 		 

//always @(posedge clk or negedge rstn_cnt[7])
//if(!rstn_cnt[7])
//	 ready <= 1'b0;
//else
//	 ready <= 1'b1;
	 
// count pixel when line valid
always @(posedge clk or negedge rstn_cnt[7])
if(!rstn_cnt[7])
	 color_cntr <= 0;
else
	 color_cntr <= lv_r ? color_cntr+1 : 0;

// count lines when frame valid
always @(posedge clk or negedge rstn_cnt[7])
if(!rstn_cnt[7])
	 ative_line_cnt <= 0;
else
	 ative_line_cnt <= fv_r ? (pixcnt ==h_total-1)?ative_line_cnt+1: ative_line_cnt : 0;



reg [23:0] data_o;
always @(posedge clk or negedge rstn_cnt[7])
begin
	if(!rstn_cnt[7])
	begin
        data_o <= 24'b0;
	end
	else
	begin
            if((ative_line_cnt >= TOP) && (ative_line_cnt < BOTTOM) &&(color_cntr >= LEFT) && (color_cntr < RIGHT)) 
            begin
                read_en <= 1'b1;
                vout_data_r <= read_data;
            end
            else 
            begin
                vout_data_r <= 'd0;
            end
	end
end

endmodule 