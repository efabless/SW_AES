/*
	Copyright 2023 secworks

	Author: Joachim Strombergson ()

	This file is auto-generated by wrapper_gen.py

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

`define		APB_BLOCK(name, init)	always @(posedge PCLK or negedge PRESETn) if(~PRESETn) name <= init;
`define		APB_REG(name, init)		`APB_BLOCK(name, init) else if(apb_we & (PADDR[15:0]==``name``_ADDR)) name <= PWDATA;
`define		APB_ICR(sz)				`APB_BLOCK(ICR_REG, sz'b0) else if(apb_we & (PADDR[15:0]==ICR_REG_ADDR)) ICR_REG <= PWDATA; else ICR_REG <= sz'd0;

module aes_core_apb (
	input	wire 		PCLK,
	input	wire 		PRESETn,
	input	wire [31:0]	PADDR,
	input	wire 		PWRITE,
	input	wire 		PSEL,
	input	wire 		PENABLE,
	input	wire [31:0]	PWDATA,
	output	wire [31:0]	PRDATA,
	output	wire 		PREADY,
	output	wire 		irq
);
	localparam[15:0] CTRL_REG_ADDR = 16'h0000;
	localparam[15:0] STATUS_REG_ADDR = 16'h0004;
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

	wire		init	= CTRL_REG[0:0];
	wire		read_data	= CTRL_REG[1:1];
	wire		encdec	= CTRL_REG[2:2];
	wire		keylen	= CTRL_REG[3:3];
	wire		ready;
	wire[7:0]	STATUS_REG	= ready;
	wire[31:0]	key[31:0]	= KEY0_REG[31:0];
	wire[31:0]	key[63:32]	= KEY1_REG[31:0];
	wire[31:0]	key[95:64]	= KEY2_REG[31:0];
	wire[31:0]	key[127:96]	= KEY3_REG[31:0];
	wire[31:0]	key[159:128]	= KEY4_REG[31:0];
	wire[31:0]	key[191:160]	= KEY5_REG[31:0];
	wire[31:0]	key[223:192]	= KEY6_REG[31:0];
	wire[31:0]	key[255:224]	= KEY7_REG[31:0];
	wire[31:0]	block[31:0]	= BLOCK0_REG[31:0];
	wire[31:0]	block[63:32]	= BLOCK1_REG[31:0];
	wire[31:0]	block[95:64]	= BLOCK2_REG[31:0];
	wire[31:0]	block[127:96]	= BLOCK3_REG[31:0];
	wire[31:0]	result[31:0];
	wire[31:0]	RESULT0_REG	= result[31:0];
	wire[31:0]	result[63:32];
	wire[31:0]	RESULT1_REG	= result[63:32];
	wire[31:0]	result[95:64];
	wire[31:0]	RESULT2_REG	= result[95:64];
	wire[31:0]	result[127:96];
	wire[31:0]	RESULT3_REG	= result[127:96];
	wire		result_valid;
	wire		_VALID_FLAG_	= result_valid;
	wire		ready;
	wire		_READY_FLAG_	= ready;
	wire[1:0]	MIS_REG	= RIS_REG & IM_REG;
	wire		apb_valid	= PSEL & PENABLE;
	wire		apb_we	= PWRITE & apb_valid;
	wire		apb_re	= ~PWRITE & apb_valid;
	wire		_clk_	= PCLK;
	wire		_rst_	= ~PRESETn;

	aes_core inst_to_wrap (
		.clk(_clk_),
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

	`APB_REG(CTRL_REG, 0)
	`APB_REG(KEY0_REG, 0)
	`APB_REG(KEY1_REG, 0)
	`APB_REG(KEY2_REG, 0)
	`APB_REG(KEY3_REG, 0)
	`APB_REG(KEY4_REG, 0)
	`APB_REG(KEY5_REG, 0)
	`APB_REG(KEY6_REG, 0)
	`APB_REG(KEY7_REG, 0)
	`APB_REG(BLOCK0_REG, 0)
	`APB_REG(BLOCK1_REG, 0)
	`APB_REG(BLOCK2_REG, 0)
	`APB_REG(BLOCK3_REG, 0)
	`APB_REG(IM_REG, 0)

	`APB_ICR(2)

	always @(posedge PCLK or negedge PRESETn)
		if(~PRESETn) RIS_REG <= 32'd0;
		else begin
			if(_VALID_FLAG_) RIS_REG[0] <= 1'b1; else if(ICR_REG[0]) RIS_REG[0] <= 1'b0;
			if(_READY_FLAG_) RIS_REG[1] <= 1'b1; else if(ICR_REG[1]) RIS_REG[1] <= 1'b0;

		end

	assign irq = |MIS_REG;

	assign	PRDATA = 
			(PADDR[15:0] == CTRL_REG_ADDR) ? CTRL_REG :
			(PADDR[15:0] == KEY0_REG_ADDR) ? KEY0_REG :
			(PADDR[15:0] == KEY1_REG_ADDR) ? KEY1_REG :
			(PADDR[15:0] == KEY2_REG_ADDR) ? KEY2_REG :
			(PADDR[15:0] == KEY3_REG_ADDR) ? KEY3_REG :
			(PADDR[15:0] == KEY4_REG_ADDR) ? KEY4_REG :
			(PADDR[15:0] == KEY5_REG_ADDR) ? KEY5_REG :
			(PADDR[15:0] == KEY6_REG_ADDR) ? KEY6_REG :
			(PADDR[15:0] == KEY7_REG_ADDR) ? KEY7_REG :
			(PADDR[15:0] == BLOCK0_REG_ADDR) ? BLOCK0_REG :
			(PADDR[15:0] == BLOCK1_REG_ADDR) ? BLOCK1_REG :
			(PADDR[15:0] == BLOCK2_REG_ADDR) ? BLOCK2_REG :
			(PADDR[15:0] == BLOCK3_REG_ADDR) ? BLOCK3_REG :
			(PADDR[15:0] == RIS_REG_ADDR) ? RIS_REG :
			(PADDR[15:0] == ICR_REG_ADDR) ? ICR_REG :
			(PADDR[15:0] == IM_REG_ADDR) ? IM_REG :
			(PADDR[15:0] == STATUS_REG_ADDR) ? STATUS_REG :
			(PADDR[15:0] == RESULT0_REG_ADDR) ? RESULT0_REG :
			(PADDR[15:0] == RESULT1_REG_ADDR) ? RESULT1_REG :
			(PADDR[15:0] == RESULT2_REG_ADDR) ? RESULT2_REG :
			(PADDR[15:0] == RESULT3_REG_ADDR) ? RESULT3_REG :
			(PADDR[15:0] == MIS_REG_ADDR) ? MIS_REG :
			32'hDEADBEEF;


	assign PREADY = 1'b1;

endmodule