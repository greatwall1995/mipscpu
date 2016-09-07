`include "defines.v"

module ex_move(
	input wire				rst,

    input wire[`AluOpBus]	aluop_i,  
    input wire[`AluSelBus]	alusel_i,  
    input wire[`RegBus]		reg1_i,  
    input wire[`RegBus]		reg2_i,

	input wire[`RegBus]		hi_i,  
    input wire[`RegBus]		lo_i,  

    input wire[`RegBus]		wb_hi_i,  
    input wire[`RegBus]		wb_lo_i,  
    input wire				wb_whilo_i,  
      
    input wire[`RegBus]		mem_hi_i,  
    input wire[`RegBus]		mem_lo_i,  
    input wire				mem_whilo_i,
	
    output reg 				wreg_o,  
    output reg[`RegBus]		wdata_o,
	 
    output reg[`RegBus]		hi_o,  
    output reg[`RegBus]		lo_o
);
	
	reg[`RegBus]	HI;  
    reg[`RegBus]	LO;
	
	always @ (*) begin
		if (rst == `RstEnable) begin  
			{HI, LO} <= {`ZeroWord, `ZeroWord};  
		end else if (mem_whilo_i == `WriteEnable) begin  
			{HI, LO} <= {mem_hi_i, mem_lo_i};   // ·Ã´æ½×¶ÎµÄÖ¸ÁîÒªÐ´HI¡¢LO¼Ä´æÆ÷  
		end else if (wb_whilo_i == `WriteEnable) begin  
			{HI, LO} <= {wb_hi_i, wb_lo_i};     // »ØÐ´½×¶ÎµÄÖ¸ÁîÒªÐ´HI¡¢LO¼Ä´æÆ÷  
		end else begin  
			{HI, LO} <= {hi_i, lo_i};
		end
	end

	always @ (*) begin  
		if (rst == `RstEnable || alusel_i != `EXE_RES_MOVE) begin
			wreg_o <= `WriteDisable;
			wdata_o <= `ZeroWord;
			{hi_o, lo_o} <= {`ZeroWord,`ZeroWord};  
		end else begin  
			case (aluop_i)
				`EXE_MOVZ_OP: begin
					{hi_o, lo_o} <= {`ZeroWord,`ZeroWord};  
					if (reg2_i == `ZeroWord) begin
						wreg_o <= `WriteEnable;
						wdata_o <= reg1_i;
					end else begin
						wreg_o <= `WriteDisable;
					end
				end
				`EXE_MOVN_OP: begin
					{hi_o, lo_o} <= {`ZeroWord,`ZeroWord};  
					if (reg2_i != `ZeroWord) begin
						wreg_o <= `WriteEnable;
						wdata_o <= reg1_i;
					end else begin
						wreg_o <= `WriteDisable;
					end
				end
				`EXE_MFHI_OP: begin
					wreg_o <= `WriteEnable;
					wdata_o <= HI;
					{hi_o, lo_o} <= {`ZeroWord,`ZeroWord};  
				end
				`EXE_MTHI_OP: begin
					wreg_o <= `WriteDisable;
					wdata_o <= `ZeroWord;
					hi_o <= reg1_i;
					lo_o <= LO;
				end
				`EXE_MFLO_OP: begin
					wreg_o <= `WriteEnable;
					wdata_o <= LO;
					{hi_o, lo_o} <= {`ZeroWord,`ZeroWord};
				end
				`EXE_MTLO_OP: begin
					wreg_o <= `WriteDisable;
					wdata_o <= `ZeroWord;
					lo_o <= reg1_i;
					hi_o <= HI;
				end
			endcase  
		end
	end
endmodule