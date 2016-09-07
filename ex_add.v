`include "defines.v"

module ex_add(
	input wire				rst,
	input wire[`AluOpBus]	aluop_i,
    input wire[`AluSelBus]	alusel_i,
    input wire[`RegBus]		reg1_i,
    input wire[`RegBus]		reg2_i,
    output reg[`RegBus]		wdata_o,
	output reg				wreg_o
);

	wire[`RegBus]	reg2_i_mux;
	wire[`RegBus]	result_sum;
	wire			ov_sum;
	
	assign reg2_i_mux = ((aluop_i == `EXE_SUB_OP)  ||   
						(aluop_i == `EXE_SUBU_OP)) ?   
						(~reg2_i) + 1 : reg2_i;
	assign result_sum = reg1_i + reg2_i_mux;
	assign ov_sum = (!reg1_i[31] && !reg2_i_mux[31] && result_sum[31])  
					|| (reg1_i[31] && reg2_i_mux[31] && !result_sum[31]);
	
	always @ (*) begin  
		if(rst == `RstEnable || alusel_i != `EXE_RES_ADD) begin  
			wdata_o <= `ZeroWord;
			wreg_o <= `WriteDisable;
		end else begin
			case (aluop_i)
				`EXE_ADD_OP, `EXE_SUB_OP: begin
					wdata_o <= result_sum;
					if (ov_sum == 1'b1) begin
						wreg_o <= `WriteDisable;
					end else begin
						wreg_o <= `WriteEnable;
					end
				end
				`EXE_ADDU_OP, `EXE_SUBU_OP: begin
					wdata_o <= result_sum;
					wreg_o <= `WriteEnable;  
				end
			endcase  
		end
	end
endmodule
