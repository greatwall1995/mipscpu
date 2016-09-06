`include "defines.v"

module ex_logic(
	input wire				rst,
	input wire[`AluOpBus]	aluop_i,
    input wire[`AluSelBus]	alusel_i,
    input wire[`RegBus]		reg1_i,
    input wire[`RegBus]		reg2_i,
    output reg[`RegBus]		wdata_o 
);
	
	always @ (*) begin
		if(rst == `RstEnable || alusel_i != `EXE_RES_LOGIC) begin  
			wdata_o <= `ZeroWord;  
		end else begin
			case (aluop_i)
				`EXE_AND_OP: begin
					wdata_o <= reg1_i & reg2_i;
				end
				`EXE_OR_OP: begin
					wdata_o <= reg1_i | reg2_i;  
				end  
				`EXE_XOR_OP: begin
					wdata_o <= reg1_i ^ reg2_i;
				end
				`EXE_NOR_OP: begin
					wdata_o <= ~(reg1_i | reg2_i);
				end
				default: begin  
					wdata_o <= `ZeroWord;  
				end  
			endcase  
		end
	end
endmodule