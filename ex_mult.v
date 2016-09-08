`include "defines.v"

module ex_mult(
	input wire				rst,

    input wire[`AluOpBus]	aluop_i,  
    input wire[`AluSelBus]	alusel_i,  
    input wire[`RegBus]		reg1_i,  
    input wire[`RegBus]		reg2_i,
	 
    output reg[`RegBus]		hi_o,  
    output reg[`RegBus]		lo_o,
	output reg				whilo_o
);

	wire[`RegBus]		reg1_mult;
	wire[`RegBus]		reg2_mult;
	wire[`DoubleRegBus]	tmp;
	reg[`DoubleRegBus]	res1;
	reg[`DoubleRegBus] res2;
	
	assign reg1_mult = reg1_i[31] == 1'b1 ? ~reg1_i + 1 : reg1_i;  
	assign reg2_mult = reg2_i[31] == 1'b1 ? ~reg2_i + 1 : reg2_i;  

	assign tmp = reg1_mult * reg2_mult;
	
	always @ (*) begin  
		if(rst == `RstEnable) begin  
			res1 <= {`ZeroWord,`ZeroWord};
			res2 <= {`ZeroWord,`ZeroWord};  
		end begin  
			if(reg1_i[31] ^ reg2_i[31] == 1'b1) begin  
				res1 <= ~tmp + 1;  
			end else begin  
				res1 <= tmp;  
			end
			res2 <= reg1_i * reg2_i;
		end  
	end  
	
	always @ (*) begin
		if (rst == `RstEnable || alusel_i != `EXE_RES_MULT) begin
			{hi_o, lo_o} <= {`ZeroWord,`ZeroWord}; 
			whilo_o <= `WriteDisable; 
		end else begin 
			whilo_o <= `WriteEnable;
			case (aluop_i)
				`EXE_MULT_OP: begin
					hi_o <= res1[63:32];
					lo_o <= res1[31:0];
				end
				`EXE_MULTU_OP: begin
					hi_o <= res2[63:32];
					lo_o <= res2[31:0];
				end
			endcase  
		end
	end
endmodule