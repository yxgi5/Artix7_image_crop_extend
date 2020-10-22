`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2020 11:42:28 PM
// Design Name: 
// Module Name: cmos_img_capture
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cmos_img_capture
(
    input   wire            rst               ,//复位信号
    input   wire            cmos_cfg_done     ,//寄存器配置完成信号 
    //摄像头接口
    input   wire            cmos_pclk         ,//cmos 数据像素时钟
    input   wire            cmos_vsync        ,//cmos 场同步信号
    input   wire            cmos_href         ,//cmos 行同步信号
    input   wire   [7:0]    cmos_data         ,//cmos 数据
    
    output  wire            cmos_hsync_d1,
    output  wire            cmos_vsync_d1,
    output  wire   [31:0]   cmos_data_wr,
    output  reg             cmos_data_vld
);

//--------------------cmos_hsync_dd--------------------
reg     [1:0]   cmos_href_dd   ;//cmos_vsync 延时信号
always @(posedge cmos_pclk)begin
    if(rst == 1'b1)begin
        cmos_href_dd <= 'd0;
    end
    else if(cmos_cfg_done==1'b0)begin
        cmos_href_dd <= 'd0;
    end
    else begin
        cmos_href_dd <= {cmos_href_dd[0],cmos_href};
    end
end

//--------------------cmos_hsync_d1--------------------
assign cmos_hsync_d1 = ~cmos_href_dd[0] & cmos_href_dd[1];


//--------------------cmos_vsync_dd--------------------
reg     [1:0]   cmos_vsync_dd   ;//cmos_vsync 延时信号
always @(posedge cmos_pclk)begin
    if(rst == 1'b1)begin
        cmos_vsync_dd <= 'd0;
    end
    else if(cmos_cfg_done==1'b0)begin
        cmos_vsync_dd <= 'd0;
    end
    else begin
        cmos_vsync_dd <= {cmos_vsync_dd[0],cmos_vsync};
    end
end
assign  cmos_vsync_d1 = ~cmos_vsync_dd[0];

//--------------------ready--------------------
reg             ready           ;//准备好接收数据（一帧完整的数据）
//接收到了帧同步信号，可以开始接收数据
always @(posedge cmos_pclk)begin
    if(rst == 1'b1)begin
        ready <= 'd0;
    end
    else if(cmos_cfg_done==1'b0)begin
        ready <= 'd0;
    end
    else if(cmos_vsync_dd[0]==1'b1 && cmos_vsync_dd[1]==1'b0)begin
        ready <= 1'b1;
    end
end


reg     [15:0]  cmos_capture_data;//捕捉到的数据
wire    [4:0]   rgb_r           ;
wire    [5:0]   rgb_g           ;
wire    [4:0]   rgb_b           ;

assign rgb_r = cmos_capture_data[15:11];
assign rgb_g = cmos_capture_data[10:5];
assign rgb_b = cmos_capture_data[4:0];

//--------------------cmos_capture_data--------------------
always @(posedge cmos_pclk)begin
    if(rst == 1'b1)begin
        cmos_capture_data <= 'd0;
    end
    else if(cmos_cfg_done==1'b0)begin
        cmos_capture_data <= 'd0;
    end
    else if(cmos_href==1'b1 && ready==1'b1)begin
        cmos_capture_data <= {cmos_capture_data[7:0],cmos_data};
    end
    else begin
        cmos_capture_data <= 'd0;
    end
end

assign cmos_data_wr = {8'h00,{rgb_r,rgb_r[2:0]},{rgb_g,rgb_g[1:0]},{rgb_b,rgb_b[2:0]}};

//--------------------cnt_data--------------------
reg     [11:0]  cnt_data        ;//计数当前已经接收了多少从cmos传来的数据
always @(posedge cmos_pclk)begin
    if(rst == 1'b1)begin
        cnt_data <= 'd0;
    end
    else if(cmos_cfg_done==1'b0)begin
        cnt_data <= 'd0;
    end
    else if(cmos_href==1'b1 && ready==1'b1)begin
        cnt_data <= cnt_data + 1'b1;
    end
    else begin
        cnt_data <= 'd0;
    end
end

//--------------------cmos_data_vld--------------------
always @(posedge cmos_pclk)begin
    if(rst == 1'b1)begin
        cmos_data_vld <= 1'd0;
    end
    else if(cnt_data[0]==1'b1)begin
        cmos_data_vld <= 1'b1;
    end
    else begin
        cmos_data_vld <= 1'b0;
    end
end


endmodule
