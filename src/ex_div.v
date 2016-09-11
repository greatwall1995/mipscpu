`include "defines.v"

`define Free	2'b00
`define On		2'b01
`define End		2'b10

module ex_div(
	input wire				rst,
	input wire				clk,

    input wire[`AluOpBus]	aluop_i,  
    input wire[`AluSelBus]	alusel_i,  
    input wire[`RegBus]		reg1_i,  
    input wire[`RegBus]		reg2_i,
	 
    output reg[`RegBus]		hi_o,  
    output reg[`RegBus]		lo_o,
	output reg				whilo_o,
	output reg				stop
);
	
	
	reg[`RegBus]	data1;
	reg[`RegBus]	data2;
	reg[`RegBus]	data1_tmp;
	reg[`RegBus]	data2_tmp;
	reg[`RegBus]	tmp;
	wire[32:0]		diff;
	reg[`RegBus]	quo;
	reg[32:0]		rmd;
	reg				sign;
	reg[5:0]		cnt;
	reg[1:0]		state;
	
	initial begin
		cnt <= 6'b000000;
		state = `Free;
	end
	
	assign diff = {1'b0, rmd[31:0]} - {1'b0, data2_tmp};

	always @ (*) begin 
		whilo_o <= `WriteDisable; 
		if (stop != `Free) begin
		end else if (rst == `RstEnable || alusel_i != `EXE_RES_DIV) begin  
			cnt <= 6'b000000;
			{hi_o, lo_o} <= {`ZeroWord,`ZeroWord};
			stop <= `NotStop;
			state <= `Free;
		end else if (reg2_i == `ZeroWord) begin
			cnt = 6'b000000;
			{hi_o, lo_o} <= {`ZeroWord,`ZeroWord};
			stop <= `NotStop;
			state <= `Free;
		end else begin
			cnt <= 6'b000000;
			data1 <= reg1_i;
			data2 <= reg2_i;
			sign <= aluop_i == `EXE_DIV_OP;
			stop <= `Stop;
			state <= `On;
			if (aluop_i == `EXE_DIV_OP && reg1_i[31] == 1'b1) begin
				tmp <= ~reg1_i + 1;
				data1_tmp <= ~reg1_i + 1;
				if (reg1_i == 32'h80000000) begin
					rmd <= {32'h00000000, 1'b1};
				end else begin
					rmd <= {32'h00000000, 1'b0};
				end
			end else begin
				tmp <= reg1_i;
				data1_tmp <= reg1_i;
				rmd <= {32'h00000000, reg1_i[31]};
			end
			if (aluop_i == `EXE_DIV_OP && reg2_i[31] == 1'b1) begin
				data2_tmp <= ~reg2_i + 1;
			end else begin
				data2_tmp <= reg2_i;
			end
		end
	end
	
	always @ (posedge clk) begin  
		if (state == `On) begin
			stop <= `Stop;
			if (cnt != 6'b100000) begin
				whilo_o <= `WriteDisable; 
				if (diff[32] == 1'b0) begin
					quo = {quo[30:0], 1'b1};
					rmd <= {diff[31:0], tmp[30]};
				end else begin
					quo = {quo[30:0], 1'b0};
					rmd <= {rmd[31:0], tmp[30]};
				end
				cnt <= cnt + 1;
				tmp <= {tmp[30:0], 1'b0};
			end else begin
				whilo_o <= `WriteEnable; 
				cnt <= 0;
				state <= `End;
				if (sign == 1'b0) begin
					lo_o <= quo;
					hi_o <= rmd[32:1];
				end else begin
					if ((data1[31] ^ data2[31]) == 1'b0) begin
						lo_o <= quo;
					end else begin
						lo_o <= ~quo + 1;
					end
					if ((data1[31] ^ rmd[32]) == 1'b0) begin
						hi_o <= rmd[32:1];
					end else begin
						hi_o <= ~rmd[32:1] + 1;
					end
				end
			end
		end else begin
			whilo_o <= `WriteDisable; 
			state <= `Free;
			stop <= `NotStop;
		end
	end
endmodule
