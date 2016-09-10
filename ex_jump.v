`include "defines.v"

module ex_jump(
	input wire				rst,
	input wire[`AluOpBus]	aluop_i,
    input wire[`AluSelBus]	alusel_i,
    input wire[`RegBus]		reg1_i,
    input wire[`RegBus]		reg2_i,
    output reg[`RegBus]		wdata_o 
);
	
	always @ (*) begin
		if(rst == `RstEnable || alusel_i != `EXE_RES_JUMP) begin  
			wdata_o <= `ZeroWord;  
		end else begin
			wdata_o <= reg1_i;
		end
	end
endmodule