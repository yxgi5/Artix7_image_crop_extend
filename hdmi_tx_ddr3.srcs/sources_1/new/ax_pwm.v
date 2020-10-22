//////////////////////////////////////////////////////////////////////////////////
//  ov5640 lcd display                                                          //
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
//   Description:  pwm model
//   pwm out period = frequency(pwm_out) * (2 ** N) / frequency(clk);
//
//================================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------------
//  2017/5/3     meisq          1.0         Original
//********************************************************************************/
`timescale 1ns / 1ps
module ax_pwm
#(
parameter N = 16 //pwm bit width 
)
(
input               clk,            //input clk
input               rst,            //reset high active
input[N - 1:0]      period,         // pwm period
input[N - 1:0]      duty,           // pulse duty
output              pwm_out         // pwm output
);
reg[N - 1:0]        period_r;       //pwm period  register
reg[N - 1:0]        duty_r;         //duty register
reg[N - 1:0]        period_cnt;     //period count
reg                 pwm_r;          //pwm register
assign pwm_out = pwm_r;
/*************************************************************************
Delay one clock cycle
****************************************************************************/
always@(posedge clk or posedge rst)
begin
    if(rst==1)
    begin
        period_r <= { N {1'b0} };
        duty_r <= { N {1'b0} };
    end
    else
    begin
        period_r <= period;
        duty_r   <= duty;
    end
end
/*************************************************************************
period count
****************************************************************************/
always@(posedge clk or posedge rst)
begin
    if(rst==1)
        period_cnt <= { N {1'b0} };
    else
        period_cnt <= period_cnt + period_r;
end
/*************************************************************************
Generating periodic pulses
****************************************************************************/
always@(posedge clk or posedge rst)
begin
    if(rst==1)
    begin
        pwm_r <= 1'b0;
    end
    else
    begin
        if(period_cnt >= duty_r)//pwm_r output high level
            pwm_r <= 1'b1;
        else
            pwm_r <= 1'b0;
    end
end

endmodule
