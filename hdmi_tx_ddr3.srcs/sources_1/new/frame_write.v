`timescale 1ns / 1ps

module frame_write
#(
	parameter MEM_DATA_BITS          = 128,
//	parameter READ_DATA_BITS         = 32,
	parameter WRITE_DATA_BITS        = 32,
	parameter ADDR_BITS              = 28,
	parameter BUSRT_BITS             = 10,
	parameter BURST_SIZE             = 100
)
(
	input                            rst,                  
	input                            mem_clk,                    // external memory controller user interface clock

	output                           wr_burst_req,               // to external memory controller,send out a burst write request
	output[BUSRT_BITS - 1:0]         wr_burst_len,               // to external memory controller,data length of the burst write request, not bytes
	output[ADDR_BITS - 1:0]          wr_burst_addr,              // to external memory controller,base address of the burst write request 
	input                            wr_burst_data_req,          // from external memory controller,write data request ,before data 1 clock
	output[MEM_DATA_BITS - 1:0]      wr_burst_data,              // to external memory controller,write data
	input                            wr_burst_finish,            // from external memory controller,burst write finish
	input                            write_clk,                  // data write module clock
	input                            write_req,                  // data write module write request,keep '1' until read_req_ack = '1'
	output                           write_req_ack,              // data write module write request response
	output                           write_finish,               // data write module write request finish
	input[ADDR_BITS - 1:0]           write_addr_0,               // data write module write request base address 0, used when write_addr_index = 0
	input[ADDR_BITS - 1:0]           write_addr_1,               // data write module write request base address 1, used when write_addr_index = 1
	input[ADDR_BITS - 1:0]           write_addr_2,               // data write module write request base address 1, used when write_addr_index = 2
	input[ADDR_BITS - 1:0]           write_addr_3,               // data write module write request base address 1, used when write_addr_index = 3
	input[1:0]                       write_addr_index,           // select valid base address from write_addr_0 write_addr_1 write_addr_2 write_addr_3
	input[ADDR_BITS - 1:0]           write_len,                  // data write module write request data length
	input                            write_en,                   // data write module write request for one data
	input[WRITE_DATA_BITS - 1:0]     write_data                  // write data
);

//wire[15:0]                           wrusedw;                    // write used words
wire[15:0]                           rdusedw;                    // read used words
//wire                                 read_fifo_aclr;             // fifo Asynchronous clear
wire                                 write_fifo_aclr;            // fifo Asynchronous clear

//instantiate an asynchronous FIFO 
afifo_32i_128o_2048 write_buf (
	.rst                         (write_fifo_aclr         ),
	.wr_clk                      (write_clk               ),
	.rd_clk                      (mem_clk                 ),
	.din                         (write_data              ),
	.wr_en                       (write_en                ),
	.rd_en                       (wr_burst_data_req       ),
	.dout                        (wr_burst_data           ),
	.full                        (                        ),
	.empty                       (                        ),
	.rd_data_count               (rdusedw                 ),
	.wr_data_count               (                        )
);
/*
afifo_16_512 write_buf
	(
	.rdclk                      (mem_clk                  ),          // Read side clock
	.wrclk                      (write_clk                ),          // Write side clock
	.aclr                       (write_fifo_aclr          ),          // Asynchronous clear
	.wrreq                      (write_en                 ),          // Write Request
	.rdreq                      (wr_burst_data_req        ),          // Read Request
	.data                       (write_data               ),          // Input Data
	.rdempty                    (                         ),          // Read side Empty flag
	.wrfull                     (                         ),          // Write side Full flag
	.rdusedw                    (rdusedw                  ),          // Read Used Words
	.wrusedw                    (                         ),          // Write Used Words
	.q                          (wr_burst_data            )
);
*/

frame_fifo_write
#
(
	.MEM_DATA_BITS              (MEM_DATA_BITS            ),
	.ADDR_BITS                  (ADDR_BITS                ),
	.BUSRT_BITS                 (BUSRT_BITS               ),
	.BURST_SIZE                 (BURST_SIZE               )
) 
frame_fifo_write_m0              
(  
	.rst                        (rst                      ),
	.mem_clk                    (mem_clk                  ),
	.wr_burst_req               (wr_burst_req             ),
	.wr_burst_len               (wr_burst_len             ),
	.wr_burst_addr              (wr_burst_addr            ),
	.wr_burst_data_req          (wr_burst_data_req        ),
	.wr_burst_finish            (wr_burst_finish          ),
	.write_req                  (write_req                ),
	.write_req_ack              (write_req_ack            ),
	.write_finish               (write_finish             ),
	.write_addr_0               (write_addr_0             ),
	.write_addr_1               (write_addr_1             ),
	.write_addr_2               (write_addr_2             ),
	.write_addr_3               (write_addr_3             ),
	.write_addr_index           (write_addr_index         ),    
	.write_len                  (write_len                ),
	.fifo_aclr                  (write_fifo_aclr          ),
	.rdusedw                    (rdusedw                  ) 
	
);

endmodule
