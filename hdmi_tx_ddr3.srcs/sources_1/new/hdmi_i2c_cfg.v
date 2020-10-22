// --------------------------------------------------------------------
// Copyright (c) 2019 by MicroPhase Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   MicroPhase grants permission to use and modify this code for use
//   in synthesis for all MicroPhase Development Boards.
//   Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  MicroPhase provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     MicroPhase Technologies Inc
//                     Shanghai, China
//
//                     web: http://www.microphase.cn/   
//                     email: support@microphase.cn
//
// --------------------------------------------------------------------
// --------------------------------------------------------------------
//
// Major Functions: 
//
// --------------------------------------------------------------------
// --------------------------------------------------------------------
//
//  Revision History:
//  Date          By            Revision    Change Description
//---------------------------------------------------------------------
//2019-11-23      Chaochen Wei  1.0          Original
//2019/                         1.1          
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module  hdmi_i2c_cfg(
    input   wire            clk         ,//输入时钟
    input   wire            rst         ,//系统复位
    output  wire            scl         ,//i2c时钟
    inout   wire            sda          //i2c数据
);


//==================================================
//parameter define
//==================================================
parameter   IDLE    =   4'b0001;
parameter   WR_CHECK=   4'b0010;
parameter   WRITE   =   4'b0100;
parameter   READ    =   4'b1000;

parameter   SYS_CYCLE   = 20;//系统时钟50M
parameter   WAIT_TIME   =  20000000;//两次传输数据的等待时间
parameter   MAX_WAIT    =   WAIT_TIME/SYS_CYCLE - 1; 

parameter   DEV_ADDR    =   8'h72;

//==================================================
//internal signals
//==================================================

reg             rd_req    	;//i2c读请求
wire            rd_done		;//i2c读响应
wire    [7:0]   rd_data   	;//i2c读出的数据
reg             wr_req   	;//i2c写请求
wire            wr_done		;//i2c写响应
wire    [7:0]   wr_data  	;//i2c写入的数据
wire    [7:0]   dev_addr	;//i2c从设备地址
wire    [7:0]   mem_addr	;//i2c从设备寄存器地址
wire            err_flag    ;//错误信号

reg     [24:0]  cnt_wait    ;
reg             ready       ;//准备好信号


reg     [3:0]   state           ;//state register
reg     [8:0]   wr_index        ;//配置寄存器索引  
reg     [8:0]   rd_index        ;//读取寄存器索引
reg     [23:0]  lut_data        ;//配置寄存器值
reg             cfg_done        ;//配置完成  
reg             start           ;//读写起始信号        


//--------------------state machine describe--------------------
always @(posedge clk)begin
    if(rst == 1'b1)begin
        state <= IDLE;
    end
    else begin
        case(state)
            IDLE:begin
                    state <= WR_CHECK;
            end

            WR_CHECK:begin  //判断当前是否已经配置完成寄存器，若是则等待读寄存器，若不是则进入WRITE状态，写寄存器
                if(cfg_done==1'b0 && ready)
                    state <= WRITE;
                else if(cfg_done==1'b1 && ready)
                    state <= READ;
            end

            WRITE:begin//一个寄存器写完，回到WR_CHECK状态
                if(wr_done)
                    state <= WR_CHECK;
                else if(cfg_done==1'b1)
                    state <= WR_CHECK;
                else
                    state <= WRITE;
            end  

            READ:begin//读寄存器完成，回到IDLE状态
                if(rd_done)
                    state <= WR_CHECK;
                else
                    state <= READ;
            end

            default:begin
                state <= IDLE;
            end
        endcase
    end
end

//--------------------cnt_wait--------------------
always @(posedge clk)begin
    if(rst == 1'b1)begin
        cnt_wait <= 'd0;//复位
    end
    else if(state==WR_CHECK)begin//等待状态或者写判断是否配置完成状态
        if(cnt_wait==MAX_WAIT)
            cnt_wait <= 'd0;
        else
            cnt_wait <= cnt_wait + 1'b1;
    end  
    else begin
        cnt_wait <= 'd0;
    end
end

//--------------------ready--------------------
always @(posedge clk)begin
    if(rst == 1'b1)begin
        ready <= 1'b0;
    end
    else if(state==WR_CHECK)begin//读到最后一个寄存器，索引值保持不变
        if(cnt_wait==MAX_WAIT)
            ready <= 1'b1;
        else
            ready <= ready;
    end
    else if(start)begin
        ready <= 1'b0; 
    end
end

always @(posedge clk)begin
    if(rst == 1'b1)begin
        lut_data <= 'ha00100;
    end
    else if(cfg_done==1'b0)begin
        case(wr_index)//配置寄存器列表
            8'd0    :   lut_data    <= {DEV_ADDR,16'h9803};  //Must be set to 0x03 for proper operation
            8'd1    :   lut_data    <= {DEV_ADDR,16'h9902};  //Must be set to Default Value
            8'd2    :   lut_data    <= {DEV_ADDR,16'h9ae0};  //Must be set to 0b1110000
            8'd3    :   lut_data    <= {DEV_ADDR,16'h9c30};  //PLL filter R1 value
            8'd4    :   lut_data    <= {DEV_ADDR,16'h9d61};  //Set clock divide
            8'd5    :   lut_data    <= {DEV_ADDR,16'ha2a4};  //Must be set to 0xA4 for proper operation
            8'd6    :   lut_data    <= {DEV_ADDR,16'ha3a4};  //Must be set to 0xA4 for proper operation
            8'd7    :   lut_data    <= {DEV_ADDR,16'ha504};  //Must be set to Default Value
            8'd8    :   lut_data    <= {DEV_ADDR,16'hab40};  //Must be set to Default Value
            8'd9    :   lut_data    <= {DEV_ADDR,16'haf14};  //0x16 Select HDMI mode; 0x14 Select DVI mode;
            8'd10   :   lut_data    <= {DEV_ADDR,16'hba60};  //No clock delay
            8'd11   :   lut_data    <= {DEV_ADDR,16'hd1ff};  //Must be set to Default Value
            8'd12   :   lut_data    <= {DEV_ADDR,16'hde10};  //Must be set to Default for proper operation
            8'd13   :   lut_data    <= {DEV_ADDR,16'he460};  //Must be set to Default Value
            8'd14   :   lut_data    <= {DEV_ADDR,16'hfa7d};  //Nbr of times to look for good phase
            8'd15   :   lut_data    <= {DEV_ADDR,16'h9803};  //Must be set to 0x03 for proper operation
            8'd16   :   lut_data    <= {DEV_ADDR,16'h0100};  //Set 'N' value at 6144
            8'd17   :   lut_data    <= {DEV_ADDR,16'h0218};  //Set 'N' value at 6144
            8'd18   :   lut_data    <= {DEV_ADDR,16'h0300};  //Set 'N' value at 6144
            8'd19   :   lut_data    <= {DEV_ADDR,16'h1470};  // Set Ch count in the channel status to 8.
            8'd20   :   lut_data    <= {DEV_ADDR,16'h1520};  //Input 444 (RGB or YCrCb) with Separate Syncs, 48kHz fs
            8'd21   :   lut_data    <= {DEV_ADDR,16'h1630};  //Output format 444, 24-bit input
            8'd22   :   lut_data    <= {DEV_ADDR,16'h1846};  //Disable CSC
            8'd23   :   lut_data    <= {DEV_ADDR,16'h4080};  //General control packet enable
            8'd24   :   lut_data    <= {DEV_ADDR,16'h4110};  //Power down control
            8'd25   :   lut_data    <= {DEV_ADDR,16'h49A8};  //Set dither mode - 12-to-10 bit
            8'd26   :   lut_data    <= {DEV_ADDR,16'h5510};  //Set RGB in AVI infoframe
            8'd27   :   lut_data    <= {DEV_ADDR,16'h5608};  //Set active format aspect
            8'd28   :   lut_data    <= {DEV_ADDR,16'h96F6};  //Set interrup
            8'd29   :   lut_data    <= {DEV_ADDR,16'h7307};  //Info frame Ch count to 8
            8'd30   :   lut_data    <= {DEV_ADDR,16'h761f};  //Set speaker allocation for 8 channels
            default:begin
                lut_data  <=  'hFFFFFF ; //Nbr of times to search for good phase
            end
        endcase
    end
    else if(cfg_done==1'b1)begin
        case(rd_index)
            8'd0    :   lut_data    <= {DEV_ADDR,16'h9803};  //Must be set to 0x03 for proper operation
            8'd1    :   lut_data    <= {DEV_ADDR,16'h9902};  //Must be set to Default Value
            8'd2    :   lut_data    <= {DEV_ADDR,16'h9ae0};  //Must be set to 0b1110000
            8'd3    :   lut_data    <= {DEV_ADDR,16'h9c30};  //PLL filter R1 value
            8'd4    :   lut_data    <= {DEV_ADDR,16'h9d61};  //Set clock divide
            8'd5    :   lut_data    <= {DEV_ADDR,16'ha2a4};  //Must be set to 0xA4 for proper operation
            8'd6    :   lut_data    <= {DEV_ADDR,16'ha3a4};  //Must be set to 0xA4 for proper operation
            8'd7    :   lut_data    <= {DEV_ADDR,16'ha504};  //Must be set to Default Value
            8'd8    :   lut_data    <= {DEV_ADDR,16'hab40};  //Must be set to Default Value
            8'd9    :   lut_data    <= {DEV_ADDR,16'haf16};  //Select HDMI mode
            8'd10   :   lut_data    <= {DEV_ADDR,16'hba60};  //No clock delay
            8'd11   :   lut_data    <= {DEV_ADDR,16'hd1ff};  //Must be set to Default Value
            8'd12   :   lut_data    <= {DEV_ADDR,16'hde10};  //Must be set to Default for proper operation
            8'd13   :   lut_data    <= {DEV_ADDR,16'he460};  //Must be set to Default Value
            8'd14   :   lut_data    <= {DEV_ADDR,16'hfa7d};  //Nbr of times to look for good phase
            8'd15   :   lut_data    <= {DEV_ADDR,16'h9803};  //Must be set to 0x03 for proper operation
            8'd16   :   lut_data    <= {DEV_ADDR,16'h0100};  //Set 'N' value at 6144
            8'd17   :   lut_data    <= {DEV_ADDR,16'h0218};  //Set 'N' value at 6144
            8'd18   :   lut_data    <= {DEV_ADDR,16'h0300};  //Set 'N' value at 6144
            8'd19   :   lut_data    <= {DEV_ADDR,16'h1470};  // Set Ch count in the channel status to 8.
            8'd20   :   lut_data    <= {DEV_ADDR,16'h1520};  //Input 444 (RGB or YCrCb) with Separate Syncs, 48kHz fs
            8'd21   :   lut_data    <= {DEV_ADDR,16'h1630};  //Output format 444, 24-bit input
            8'd22   :   lut_data    <= {DEV_ADDR,16'h1846};  //Disable CSC
            8'd23   :   lut_data    <= {DEV_ADDR,16'h4080};  //General control packet enable
            8'd24   :   lut_data    <= {DEV_ADDR,16'h4110};  //Power down control
            8'd25   :   lut_data    <= {DEV_ADDR,16'h49A8};  //Set dither mode - 12-to-10 bit
            8'd26   :   lut_data    <= {DEV_ADDR,16'h5510};  //Set RGB in AVI infoframe
            8'd27   :   lut_data    <= {DEV_ADDR,16'h5608};  //Set active format aspect
            8'd28   :   lut_data    <= {DEV_ADDR,16'h96F6};  //Set interrup
            8'd29   :   lut_data    <= {DEV_ADDR,16'h7307};  //Info frame Ch count to 8
            8'd30   :   lut_data    <= {DEV_ADDR,16'h761f};  //Set speaker allocation for 8 channels
            default:begin
                lut_data  <=  'hFFFFFF ; //Nbr of times to search for good phase
            end
        endcase
    end
end

//按照设备地址，寄存器地址和写入的数据的顺序，赋值
assign {dev_addr,mem_addr,wr_data} = lut_data;

//--------------------wr_index--------------------
always @(posedge clk)begin
    if(rst == 1'b1)begin
        wr_index <= 'd0;//写寄存器索引
    end
    else if(cfg_done)begin//配置寄存器全部完成后保持位0
        wr_index <= 'd0;
    end
    else if(wr_done && cfg_done==1'b0) begin//配置寄存器未完成，并且接收到写响应
        wr_index <= wr_index + 1'b1;
    end
    else begin
        wr_index <= wr_index;
    end
end

//--------------------rd_index--------------------
always @(posedge clk)begin
    if(rst == 1'b1)begin
        rd_index <= 'd0;//读寄存器索引
    end
    else if(dev_addr==8'hff)begin//读到最后一个寄存器，索引值保持不变
        rd_index <= rd_index;
    end
    else if(rd_done && cfg_done==1'b1) begin//接收到读响应，索引值加一
        rd_index <= rd_index + 1'b1;
    end
    else begin
        rd_index <= rd_index;
    end
end

//--------------------wr_req--------------------
always @(posedge clk)begin
    if(rst == 1'b1)begin
        wr_req <= 1'b0;
    end
    else if(cfg_done==1'b1)begin//接收到写响应时，写请求变低
        wr_req <= 1'b0;
    end
    else if(wr_done)begin//接收到写响应时，写请求变低
        wr_req <= 1'b0;
    end
    else if(state==WR_CHECK && cfg_done==1'b0 && ready && dev_addr!=8'hff)begin//配置寄存器还没有全部完成，在WR_CHECK状态下产生写请求
        wr_req <= 1'b1;
    end
    else begin
        wr_req <= wr_req;
    end
end

//--------------------rd_req--------------------
always @(posedge clk)begin
    if(rst == 1'b1)begin
        rd_req <= 1'b0;
    end
    else if(dev_addr==8'hff && state==WR_CHECK)begin//读取配置完成
        rd_req <= 1'b0;
    end
    else if(rd_done)begin//接收到读响应，读请求取消
        rd_req <= 1'b0;
    end
    else if(cfg_done && ready && state==WR_CHECK && dev_addr!=8'hff)begin//在WR_CHECK状态下，检测到配置完成，产生读请求
        rd_req <= 1'b1;
    end
    else begin
        rd_req <= rd_req;
    end
end

//--------------------cfg_done--------------------
always @(posedge clk)begin
    if(rst == 1'b1)begin
        cfg_done <= 1'b0;//配置寄存器结束标志
    end
    else if(dev_addr ==8'hff)begin
        cfg_done <= 1'b1;
    end
end

//--------------------start--------------------
always @(posedge clk)begin
    if(rst == 1'b1)begin
        start <= 1'b0;//配置寄存器结束标志
    end
    else if(state==WR_CHECK && cfg_done==1'b0 && ready && dev_addr!=8'hff)begin//写开始
        start <= 1'b1;
    end
    else if(cfg_done==1'b1 && ready && state==WR_CHECK && dev_addr!=8'hff)begin//读开始
        start <= 1'b1;
    end
    else begin
    	start <= 1'b0;
    end
end
    
	i2c_driver inst_i2c_driver (
			.clk      (clk),
			.rst      (rst),
			.wr_req   (wr_req),
			.rd_req   (rd_req),
			.start    (start),
			.dev_addr (dev_addr),
			.mem_addr (mem_addr),
			.wr_data  (wr_data),
			.rd_data  (rd_data),
			.rd_done  (rd_done),
			.wr_done  (wr_done),
            .err_flag (err_flag),
			.scl      (scl),
			.sda      (sda)
		);


endmodule

