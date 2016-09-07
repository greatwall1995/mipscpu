`include "defines.v"

module ex_shift(
	input wire				rst,
	input wire[`AluOpBus]	aluop_i,
    input wire[`AluSelBus]	alusel_i,
    input wire[`RegBus]		reg1_i,
    input wire[`RegBus]		reg2_i,
    output reg[`RegBus]		wdata_o 
);

	always @ (*) begin  
		if(rst == `RstEnable || alusel_i != `EXE_RES_SHIFT) begin  
			wdata_o <= `ZeroWord;  
		end else begin  
			case (aluop_i)
				`EXE_SLL_OP: begin
					wdata_o <= (reg2_i << reg1_i[4:0]);
				end
				`EXE_SRL_OP: begin  
					wdata_o <= (reg2_i >> reg1_i[4:0]); 
				end  
				`EXE_SRA_OP: begin
					wdata_o <= (({32{reg2_i[31]}}<<(6'd32-{1'b0,reg1_i[4:0]})) | reg2_i >> reg1_i[4:0]);
				end
				default: begin  
					wdata_o <= `ZeroWord;
				end  
			endcase  
		end
	end
endmodule