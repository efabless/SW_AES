/*
	Copyright 2023 secworks

	Author: Joachim Strombergson ()

	This file is auto-generated by wrapper_gen.py on 2023-11-05

	Permission is hereby granted, free of charge, to any person obtaining
	a copy of this software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be
	included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
	OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
	WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/


`timescale			1ns/1ns
`default_nettype	none





module SW_AES_AHBL #(parameter CLKG=1)(
	input	wire 		HCLK,
	input	wire 		HRESETn,
	input	wire [31:0]	HADDR,
	input	wire 		HWRITE,
	input	wire [1:0]	HTRANS,
	input	wire 		HREADY,
	input	wire 		HSEL,
	input	wire [2:0]	HSIZE,
	input	wire [31:0]	HWDATA,
	output	wire [31:0]	HRDATA,
	output	wire 		HREADYOUT,
	output	wire 		irq
);
	localparam[15:0] STATUS_REG_ADDR = 16'h0000;
	localparam[15:0] CTRL_REG_ADDR = 16'h0004;
	localparam[15:0] KEY0_REG_ADDR = 16'h0008;
	localparam[15:0] KEY1_REG_ADDR = 16'h000c;
	localparam[15:0] KEY2_REG_ADDR = 16'h0010;
	localparam[15:0] KEY3_REG_ADDR = 16'h0014;
	localparam[15:0] KEY4_REG_ADDR = 16'h0018;
	localparam[15:0] KEY5_REG_ADDR = 16'h001c;
	localparam[15:0] KEY6_REG_ADDR = 16'h0020;
	localparam[15:0] KEY7_REG_ADDR = 16'h0024;
	localparam[15:0] BLOCK0_REG_ADDR = 16'h0028;
	localparam[15:0] BLOCK1_REG_ADDR = 16'h002c;
	localparam[15:0] BLOCK2_REG_ADDR = 16'h0030;
	localparam[15:0] BLOCK3_REG_ADDR = 16'h0034;
	localparam[15:0] RESULT0_REG_ADDR = 16'h0038;
	localparam[15:0] RESULT1_REG_ADDR = 16'h003c;
	localparam[15:0] RESULT2_REG_ADDR = 16'h0040;
	localparam[15:0] RESULT3_REG_ADDR = 16'h0044;
	localparam[15:0] ICR_REG_ADDR = 16'h0f00;
	localparam[15:0] RIS_REG_ADDR = 16'h0f04;
	localparam[15:0] IM_REG_ADDR = 16'h0f08;
	localparam[15:0] MIS_REG_ADDR = 16'h0f0c;
	localparam[15:0] CLKG_REG_ADDR = 16'hF000;

	reg             last_HSEL;
	reg [31:0]      last_HADDR;
	reg             last_HWRITE;
	reg [1:0]       last_HTRANS;

	always@ (posedge HCLK or negedge HRESETn) begin
		if (!HRESETn) begin
			last_HSEL       <= 0;
			last_HADDR      <= 0;
			last_HWRITE     <= 0;
			last_HTRANS     <= 0;
		end else if (HREADY) begin
			last_HSEL       <= HSEL;
			last_HADDR      <= HADDR;
			last_HWRITE     <= HWRITE;
			last_HTRANS     <= HTRANS;
		end
	end

	reg	[7:0]	CTRL_REG;
	reg	[31:0]	KEY0_REG;
	reg	[31:0]	KEY1_REG;
	reg	[31:0]	KEY2_REG;
	reg	[31:0]	KEY3_REG;
	reg	[31:0]	KEY4_REG;
	reg	[31:0]	KEY5_REG;
	reg	[31:0]	KEY6_REG;
	reg	[31:0]	KEY7_REG;
	reg	[31:0]	BLOCK0_REG;
	reg	[31:0]	BLOCK1_REG;
	reg	[31:0]	BLOCK2_REG;
	reg	[31:0]	BLOCK3_REG;
	reg	[1:0]	RIS_REG;
	reg	[1:0]	ICR_REG;
	reg	[1:0]	IM_REG;
	reg		init;
	reg		next;

	wire		ready, result_valid;
	wire[7:0]	STATUS_REG	= {6'b0, ready, result_valid};
	wire		encdec	= CTRL_REG[2:2];
	wire		keylen	= CTRL_REG[3:3];
	wire[255:0] key;
	assign	key[31:0]	= KEY0_REG[31:0];
	assign	key[63:32]	= KEY1_REG[31:0];
	assign	key[95:64]	= KEY2_REG[31:0];
	assign	key[127:96]	= KEY3_REG[31:0];
	assign	key[159:128]	= KEY4_REG[31:0];
	assign	key[191:160]	= KEY5_REG[31:0];
	assign	key[223:192]	= KEY6_REG[31:0];
	assign	key[255:224]	= KEY7_REG[31:0];
	wire[127:0] block;
	assign	block[31:0]	= BLOCK0_REG[31:0];
	assign	block[63:32]	= BLOCK1_REG[31:0];
	assign	block[95:64]	= BLOCK2_REG[31:0];
	assign	block[127:96]	= BLOCK3_REG[31:0];
	wire[127:0]	result;
	wire[31:0]	RESULT0_REG	= result[31:0];
	wire[31:0]	RESULT1_REG	= result[63:32];
	wire[31:0]	RESULT2_REG	= result[95:64];
	wire[31:0]	RESULT3_REG	= result[127:96];
	wire		_VALID_FLAG_	= result_valid;
	wire		_READY_FLAG_	= ready;
	wire[1:0]	MIS_REG	= RIS_REG & IM_REG;
	wire		ahbl_valid	= last_HSEL & last_HTRANS[1];
	wire		ahbl_we	= last_HWRITE & ahbl_valid;
	wire		ahbl_re	= ~last_HWRITE & ahbl_valid;
	// wire		_clk_	= HCLK;
	wire		_rst_	= ~HRESETn;
	wire			 gclk;
	generate
        if(CLKG == 1) begin
			reg         CLKG_REG;
            always @(posedge HCLK or negedge HRESETn) if(~HRESETn) CLKG_REG <= 0; else if(ahbl_we & (last_HADDR[15:0]==CLKG_REG_ADDR)) CLKG_REG <= HWDATA[1-1:0];
			ef_gating_cell clk_gate_cell(
				   .clk(HCLK),
				   .clk_en(CLKG_REG),
				   .clk_o(gclk)
			   );
        end else
            assign gclk   = HCLK;
    endgenerate

	aes_core inst_to_wrap (
		.clk(gclk),
		.reset_n(~_rst_),
		.encdec(encdec),
		.init(init),
		.next(next),
		.ready(ready),
		.key(key),
		.keylen(keylen),
		.block(block),
		.result(result),
		.result_valid(result_valid)
	);

	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) CTRL_REG <= 0; else if(ahbl_we & (last_HADDR[15:0]==CTRL_REG_ADDR)) CTRL_REG <= HWDATA[8-1:0];
	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) KEY0_REG <= 0; else if(ahbl_we & (last_HADDR[15:0]==KEY0_REG_ADDR)) KEY0_REG <= HWDATA[32-1:0];
	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) KEY1_REG <= 0; else if(ahbl_we & (last_HADDR[15:0]==KEY1_REG_ADDR)) KEY1_REG <= HWDATA[32-1:0];
	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) KEY2_REG <= 0; else if(ahbl_we & (last_HADDR[15:0]==KEY2_REG_ADDR)) KEY2_REG <= HWDATA[32-1:0];
	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) KEY3_REG <= 0; else if(ahbl_we & (last_HADDR[15:0]==KEY3_REG_ADDR)) KEY3_REG <= HWDATA[32-1:0];
	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) KEY4_REG <= 0; else if(ahbl_we & (last_HADDR[15:0]==KEY4_REG_ADDR)) KEY4_REG <= HWDATA[32-1:0];
	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) KEY5_REG <= 0; else if(ahbl_we & (last_HADDR[15:0]==KEY5_REG_ADDR)) KEY5_REG <= HWDATA[32-1:0];
	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) KEY6_REG <= 0; else if(ahbl_we & (last_HADDR[15:0]==KEY6_REG_ADDR)) KEY6_REG <= HWDATA[32-1:0];
	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) KEY7_REG <= 0; else if(ahbl_we & (last_HADDR[15:0]==KEY7_REG_ADDR)) KEY7_REG <= HWDATA[32-1:0];
	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) BLOCK0_REG <= 0; else if(ahbl_we & (last_HADDR[15:0]==BLOCK0_REG_ADDR)) BLOCK0_REG <= HWDATA[32-1:0];
	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) BLOCK1_REG <= 0; else if(ahbl_we & (last_HADDR[15:0]==BLOCK1_REG_ADDR)) BLOCK1_REG <= HWDATA[32-1:0];
	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) BLOCK2_REG <= 0; else if(ahbl_we & (last_HADDR[15:0]==BLOCK2_REG_ADDR)) BLOCK2_REG <= HWDATA[32-1:0];
	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) BLOCK3_REG <= 0; else if(ahbl_we & (last_HADDR[15:0]==BLOCK3_REG_ADDR)) BLOCK3_REG <= HWDATA[32-1:0];
	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) IM_REG <= 0; else if(ahbl_we & (last_HADDR[15:0]==IM_REG_ADDR)) IM_REG <= HWDATA[2-1:0];

	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) ICR_REG <= 2'b0; else if(ahbl_we & (last_HADDR[15:0]==ICR_REG_ADDR)) ICR_REG <= HWDATA[2-1:0]; else ICR_REG <= 2'd0;

	always @(posedge HCLK or negedge HRESETn)
		if(~HRESETn) RIS_REG <= 32'd0;
		else begin
			if(_VALID_FLAG_) RIS_REG[0] <= 1'b1; else if(ICR_REG[0]) RIS_REG[0] <= 1'b0;
			if(_READY_FLAG_) RIS_REG[1] <= 1'b1; else if(ICR_REG[1]) RIS_REG[1] <= 1'b0;

		end

	reg valid_ctrl_wr;
	always @(posedge HCLK or negedge HRESETn) 
        if (~HRESETn) begin
            init <= 1'h0;  
            next <= 1'h0; 
			valid_ctrl_wr <= 1'b0; 
		end else if (valid_ctrl_wr) begin
            init <= CTRL_REG[0];  
            next <= CTRL_REG[1];  
			valid_ctrl_wr <= last_HADDR[15:0]==CTRL_REG_ADDR & ahbl_we;
		end else begin 
            init <= 1'h0;
            next <= 1'h0;
			valid_ctrl_wr <= last_HADDR[15:0]==CTRL_REG_ADDR & ahbl_we;
		end

	assign irq = |MIS_REG;

	assign	HRDATA = 
			(last_HADDR[15:0] == CTRL_REG_ADDR) ? CTRL_REG :
			(last_HADDR[15:0] == KEY0_REG_ADDR) ? KEY0_REG :
			(last_HADDR[15:0] == KEY1_REG_ADDR) ? KEY1_REG :
			(last_HADDR[15:0] == KEY2_REG_ADDR) ? KEY2_REG :
			(last_HADDR[15:0] == KEY3_REG_ADDR) ? KEY3_REG :
			(last_HADDR[15:0] == KEY4_REG_ADDR) ? KEY4_REG :
			(last_HADDR[15:0] == KEY5_REG_ADDR) ? KEY5_REG :
			(last_HADDR[15:0] == KEY6_REG_ADDR) ? KEY6_REG :
			(last_HADDR[15:0] == KEY7_REG_ADDR) ? KEY7_REG :
			(last_HADDR[15:0] == BLOCK0_REG_ADDR) ? BLOCK0_REG :
			(last_HADDR[15:0] == BLOCK1_REG_ADDR) ? BLOCK1_REG :
			(last_HADDR[15:0] == BLOCK2_REG_ADDR) ? BLOCK2_REG :
			(last_HADDR[15:0] == BLOCK3_REG_ADDR) ? BLOCK3_REG :
			(last_HADDR[15:0] == RIS_REG_ADDR) ? RIS_REG :
			(last_HADDR[15:0] == ICR_REG_ADDR) ? ICR_REG :
			(last_HADDR[15:0] == IM_REG_ADDR) ? IM_REG :
			(last_HADDR[15:0] == STATUS_REG_ADDR) ? STATUS_REG :
			(last_HADDR[15:0] == RESULT0_REG_ADDR) ? RESULT0_REG :
			(last_HADDR[15:0] == RESULT1_REG_ADDR) ? RESULT1_REG :
			(last_HADDR[15:0] == RESULT2_REG_ADDR) ? RESULT2_REG :
			(last_HADDR[15:0] == RESULT3_REG_ADDR) ? RESULT3_REG :
			(last_HADDR[15:0] == MIS_REG_ADDR) ? MIS_REG :
			32'hDEADBEEF;


	assign HREADYOUT = 1'b1;

endmodule
