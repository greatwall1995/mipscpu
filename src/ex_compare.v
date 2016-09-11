`include "defines.v"

module ex_compare(
	input wire				rst,
	input wire[`AluOpBus]	aluop_i,
    input wire[`AluSelBus]	alusel_i,
    input wire[`RegBus]		reg1_i,
    input wire[`RegBus]		reg2_i,
    output reg[`RegBus]		wdata_o 
);

	always @ (*) begin  
		if(rst == `RstEnable || alusel_i != `EXE_RES_COMPARE) begin  
			wdata_o <= `ZeroWord;  
		end else begin  
			case (aluop_i)
				`EXE_SLT_OP: begin
					if (reg1_i[31] != reg2_i[31]) begin
						wdata_o <= (reg1_i[31] > reg2_i[31]);
					end else begin
						wdata_o <= (reg1_i < reg2_i);
					end
				end
				`EXE_SLTU_OP: begin  
					wdata_o <= reg1_i < reg2_i;  
				end
			endcase  
		end
	end
endmodule
