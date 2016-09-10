`include "defines.v"

module id(  
	input wire					rst,
	input wire[`InstAddrBus]	pc_i,  
	input wire[`InstBus]		inst_i,  
		
	// ��ȡ��Regfile��ֵ  
	input wire[`RegBus]			reg1_data_i,  
	input wire[`RegBus]			reg2_data_i,  
	
	// �����Regfile����Ϣ  
	output reg					reg1_read_o,  
	output reg					reg2_read_o,       
	output reg[`RegAddrBus]		reg1_addr_o,  
	output reg[`RegAddrBus]		reg2_addr_o,   
	
	// �͵�ִ�н׶ε���Ϣ  
	output reg[`AluOpBus]		aluop_o,  
	output reg[`AluSelBus]		alusel_o,  
	output reg[`RegBus]			reg1_o,  
	output reg[`RegBus]			reg2_o,  
	output reg[`RegAddrBus]		wd_o,  
	output reg					wreg_o,
	output reg					branch_flag_o,
	output reg[`InstAddrBus]	branch_target_o
);
    
	// ȡ��ָ���ָ���룬������  
	// ����oriָ��ֻ��ͨ���жϵ�26-31bit��ֵ�������ж��Ƿ���oriָ��  
	wire[5:0] op  = inst_i[31:26];
	wire[4:0] op2 = inst_i[10:6];
	wire[5:0] op3 = inst_i[5:0];
	wire[4:0] op4 = inst_i[20:16];
	
	// ����ָ��ִ����Ҫ��������  
	reg[`RegBus] imm;
	reg[`RegAddrBus] reg1;
	reg[`RegAddrBus] reg2;
	
	// ָʾָ���Ƿ���Ч  
	reg instvalid;  			// ?????????????????????
	
	wire[`InstAddrBus] pc_plus_4;
	wire[`InstAddrBus] pc_plus_8;
	
	assign pc_plus_4 = pc_i + 4;
	assign pc_plus_8 = pc_i + 8;
	
	initial begin
		reg1 <= `RegNumLog2'h0;
		reg2 <= `RegNumLog2'h0;
	end
	
/**************************************************************** 
***********             ��һ�Σ���ָ���������             ********* 
*****************************************************************/  
  
	always @ (*) begin      
		if (rst == `RstEnable) begin  
			aluop_o     <= `EXE_NOP_OP;  
			alusel_o    <= `EXE_RES_NOP;  
			wd_o        <= `NOPRegAddr;  
			wreg_o      <= `WriteDisable;  
			instvalid   <= `InstValid;  
			reg1_read_o <= 1'b0;  
			reg2_read_o <= 1'b0;  
			reg1_addr_o <= `NOPRegAddr;  
			reg2_addr_o <= `NOPRegAddr;  
			imm         <= 32'h0;
			branch_flag_o <= `NotBranch;
		end else begin  
		
			reg1_addr_o <= inst_i[25:21];  // Ĭ��ͨ��Regfile���˿�1��ȡ�ļĴ�����ַ  
			reg2_addr_o <= inst_i[20:16];  // Ĭ��ͨ��Regfile���˿�2��ȡ�ļĴ�����ַ  
			branch_flag_o <= `NotBranch;
			
			case (op)
				`EXE_SPECIAL_INST: begin
					wd_o  <= inst_i[15:11];
					case (op3)
						`EXE_AND: begin
							wreg_o      <= `WriteEnable;
							aluop_o     <= `EXE_AND_OP;
							alusel_o    <= `EXE_RES_LOGIC;
							reg1_read_o <= 1'b1;
							reg2_read_o <= 1'b1;
							instvalid   <= `InstValid;
						end
						`EXE_OR: begin
							wreg_o      <= `WriteEnable;
							aluop_o     <= `EXE_OR_OP;
							alusel_o    <= `EXE_RES_LOGIC;
							reg1_read_o <= 1'b1;
							reg2_read_o <= 1'b1;
							instvalid   <= `InstValid;
						end
						`EXE_XOR: begin
							wreg_o      <= `WriteEnable;
							aluop_o     <= `EXE_XOR_OP;
							alusel_o    <= `EXE_RES_LOGIC;
							reg1_read_o <= 1'b1;
							reg2_read_o <= 1'b1;
							instvalid   <= `InstValid;
						end
						`EXE_NOR: begin
							wreg_o      <= `WriteEnable;
							aluop_o     <= `EXE_NOR_OP;
							alusel_o    <= `EXE_RES_LOGIC;
							reg1_read_o <= 1'b1;
							reg2_read_o <= 1'b1;
							instvalid   <= `InstValid;
						end
						`EXE_SLT: begin
							wreg_o      <= `WriteEnable;
							aluop_o     <= `EXE_SLT_OP;
							alusel_o    <= `EXE_RES_COMPARE;
							reg1_read_o <= 1'b1;
							reg2_read_o <= 1'b1;
							instvalid   <= `InstValid;
						end
						`EXE_SLTU: begin
							wreg_o      <= `WriteEnable;
							aluop_o     <= `EXE_SLTU_OP;
							alusel_o    <= `EXE_RES_COMPARE;
							reg1_read_o <= 1'b1;
							reg2_read_o <= 1'b1;
							instvalid   <= `InstValid;
						end
						`EXE_SLL: begin
							wreg_o      <= `WriteEnable;
							aluop_o     <= `EXE_SLL_OP;
							alusel_o    <= `EXE_RES_SHIFT;
							reg1_read_o <= 1'b0;
							reg2_read_o <= 1'b1;
							instvalid   <= `InstValid;
							imm[4:0]    <= inst_i[10:6];
						end
						`EXE_SRL: begin
							wreg_o      <= `WriteEnable;
							aluop_o     <= `EXE_SRL_OP;
							alusel_o    <= `EXE_RES_SHIFT;
							reg1_read_o <= 1'b0;
							reg2_read_o <= 1'b1;
							instvalid   <= `InstValid;
							imm[4:0]    <= inst_i[10:6];
						end
						`EXE_SRA: begin
							wreg_o      <= `WriteEnable;
							aluop_o     <= `EXE_SRA_OP;
							alusel_o    <= `EXE_RES_SHIFT;
							reg1_read_o <= 1'b0;
							reg2_read_o <= 1'b1;
							instvalid   <= `InstValid;
							imm[4:0]    <= inst_i[10:6];
						end
						`EXE_SLLV: begin
							wreg_o      <= `WriteEnable;  
							aluop_o     <= `EXE_SLL_OP;  
							alusel_o    <= `EXE_RES_SHIFT;  
							reg1_read_o <= 1'b1;  
							reg2_read_o <= 1'b1;  
							instvalid   <= `InstValid;
						end
						`EXE_SRLV: begin
							wreg_o      <= `WriteEnable;  
							aluop_o     <= `EXE_SRL_OP;  
							alusel_o    <= `EXE_RES_SHIFT;  
							reg1_read_o <= 1'b1;  
							reg2_read_o <= 1'b1;  
							instvalid   <= `InstValid;
						end
						`EXE_SRAV: begin
							wreg_o      <= `WriteEnable;  
							aluop_o     <= `EXE_SRA_OP;  
							alusel_o    <= `EXE_RES_SHIFT;  
							reg1_read_o <= 1'b1;  
							reg2_read_o <= 1'b1;  
							instvalid   <= `InstValid;
						end
						`EXE_ADD: begin
							wreg_o      <= `WriteEnable;  
							aluop_o     <= `EXE_ADD_OP;  
							alusel_o    <= `EXE_RES_ADD;  
							reg1_read_o <= 1'b1;  
							reg2_read_o <= 1'b1;  
							instvalid   <= `InstValid;
						end
						`EXE_ADDU: begin
							wreg_o      <= `WriteEnable;  
							aluop_o     <= `EXE_ADDU_OP;  
							alusel_o    <= `EXE_RES_ADD;  
							reg1_read_o <= 1'b1;  
							reg2_read_o <= 1'b1;  
							instvalid   <= `InstValid;
						end
						`EXE_SUB: begin
							wreg_o      <= `WriteEnable;  
							aluop_o     <= `EXE_SUB_OP;  
							alusel_o    <= `EXE_RES_ADD;  
							reg1_read_o <= 1'b1;  
							reg2_read_o <= 1'b1;  
							instvalid   <= `InstValid;
						end
						`EXE_SUBU: begin
							wreg_o      <= `WriteEnable;  
							aluop_o     <= `EXE_SUBU_OP;  
							alusel_o    <= `EXE_RES_ADD;  
							reg1_read_o <= 1'b1;  
							reg2_read_o <= 1'b1;  
							instvalid   <= `InstValid;
						end
						`EXE_MOVZ: begin
							wreg_o      <= `WriteEnable;  
							aluop_o     <= `EXE_MOVZ_OP;  
							alusel_o    <= `EXE_RES_MOVE;  
							reg1_read_o <= 1'b1;  
							reg2_read_o <= 1'b1;  
							instvalid   <= `InstValid;
						end
						`EXE_MOVN: begin
							wreg_o      <= `WriteEnable;  
							aluop_o     <= `EXE_MOVN_OP;  
							alusel_o    <= `EXE_RES_MOVE;  
							reg1_read_o <= 1'b1;  
							reg2_read_o <= 1'b1;  
							instvalid   <= `InstValid;
						end
						`EXE_MFHI: begin
							wreg_o      <= `WriteEnable;  
							aluop_o     <= `EXE_MFHI_OP;  
							alusel_o    <= `EXE_RES_MOVE;  
							reg1_read_o <= 1'b0;  
							reg2_read_o <= 1'b0;  
							instvalid   <= `InstValid;
						end
						`EXE_MTHI: begin
							wreg_o      <= `WriteDisable;  
							aluop_o     <= `EXE_MTHI_OP;  
							alusel_o    <= `EXE_RES_MOVE;  
							reg1_read_o <= 1'b1;  
							reg2_read_o <= 1'b0;  
							instvalid   <= `InstValid;
						end
						`EXE_MFLO: begin
							wreg_o      <= `WriteEnable;  
							aluop_o     <= `EXE_MFLO_OP;  
							alusel_o    <= `EXE_RES_MOVE;  
							reg1_read_o <= 1'b0;
							reg2_read_o <= 1'b0;
							instvalid   <= `InstValid;
						end
						`EXE_MTLO: begin
							wreg_o      <= `WriteDisable;  
							aluop_o     <= `EXE_MTLO_OP;  
							alusel_o    <= `EXE_RES_MOVE;  
							reg1_read_o <= 1'b1;
							reg2_read_o <= 1'b0;
							instvalid   <= `InstValid;
						end
						`EXE_MULT: begin
							wreg_o      <= `WriteDisable;  
							aluop_o     <= `EXE_MULT_OP;  
							alusel_o    <= `EXE_RES_MULT;  
							reg1_read_o <= 1'b1;
							reg2_read_o <= 1'b1;
							instvalid   <= `InstValid;
						end
						`EXE_MULTU: begin
							wreg_o      <= `WriteDisable;  
							aluop_o     <= `EXE_MULTU_OP;  
							alusel_o    <= `EXE_RES_MULT;  
							reg1_read_o <= 1'b1;
							reg2_read_o <= 1'b1;
							instvalid   <= `InstValid;
						end
						`EXE_DIV: begin
							wreg_o      <= `WriteDisable;
							aluop_o     <= `EXE_DIV_OP;
							alusel_o    <= `EXE_RES_DIV;
							reg1_read_o <= 1'b1;
							reg2_read_o <= 1'b1;
							instvalid   <= `InstValid;
						end
						`EXE_DIVU: begin
							wreg_o      <= `WriteDisable;
							aluop_o     <= `EXE_DIVU_OP;
							alusel_o    <= `EXE_RES_DIV;
							reg1_read_o <= 1'b1;
							reg2_read_o <= 1'b1;
							instvalid   <= `InstValid;
						end
						`EXE_JR: begin
							wreg_o		<= `WriteDisable;
							aluop_o		<= `EXE_NOP_OP;
							alusel_o	<= `EXE_RES_NOP;
							reg1_read_o	<= 1'b1;
							reg2_read_o	<= 1'b0;
							instvalid	<= `InstValid;
						end
						`EXE_JR: begin
							wreg_o		<= `WriteDisable;
							aluop_o		<= `EXE_NOP_OP;
							alusel_o	<= `EXE_RES_NOP;
							reg1_read_o	<= 1'b1;
							reg2_read_o	<= 1'b0;
							instvalid	<= `InstValid;
						end
						`EXE_JALR: begin
							wreg_o		<= `WriteEnable;
							aluop_o		<= `EXE_JAL_OP;
							alusel_o	<= `EXE_RES_JUMP;
							reg1_read_o	<= 1'b0;
							reg2_read_o	<= 1'b0;
							instvalid	<= `InstValid;
						end
						default: begin 
							aluop_o     <= `EXE_NOP_OP;  
							alusel_o    <= `EXE_RES_NOP;  
							wd_o        <= inst_i[15:11];  
							wreg_o      <= `WriteDisable;  
							instvalid   <= `InstInvalid;      
							reg1_read_o <= 1'b0;  
							reg2_read_o <= 1'b0; 
							imm <= `ZeroWord;
						end
					endcase
				end
				`EXE_ANDI: begin
					wreg_o      <= `WriteEnable;
					aluop_o     <= `EXE_AND_OP;
					alusel_o    <= `EXE_RES_LOGIC;
					reg1_read_o <= 1'b1;
					reg2_read_o <= 1'b0;
					imm         <= {16'h0, inst_i[15:0]};
					wd_o        <= inst_i[20:16];
					instvalid   <= `InstValid;
				end
				`EXE_ORI: begin
					wreg_o      <= `WriteEnable;
					aluop_o     <= `EXE_OR_OP;
					alusel_o    <= `EXE_RES_LOGIC;
					reg1_read_o <= 1'b1;
					reg2_read_o <= 1'b0;
					imm         <= {16'h0, inst_i[15:0]};
					wd_o        <= inst_i[20:16];
					instvalid   <= `InstValid;
				end
				`EXE_XORI: begin
					wreg_o      <= `WriteEnable;
					aluop_o     <= `EXE_XOR_OP;
					alusel_o    <= `EXE_RES_LOGIC;
					reg1_read_o <= 1'b1;
					reg2_read_o <= 1'b0;
					imm         <= {16'h0, inst_i[15:0]};
					wd_o        <= inst_i[20:16];
					instvalid   <= `InstValid;
				end
				`EXE_LUI: begin
					wreg_o      <= `WriteEnable;
					aluop_o     <= `EXE_XOR_OP;
					alusel_o    <= `EXE_RES_LOGIC;
					reg1_read_o <= 1'b1;
					reg2_read_o <= 1'b0;
					imm         <= {inst_i[15:0], 16'h0};
					wd_o        <= inst_i[20:16];
					instvalid   <= `InstValid;
				end
				`EXE_SLTI: begin
					wreg_o      <= `WriteEnable;
					aluop_o     <= `EXE_SLT_OP;
					alusel_o    <= `EXE_RES_COMPARE;
					reg1_read_o <= 1'b1;
					reg2_read_o <= 1'b0;
					imm         <= {{16{inst_i[15]}}, inst_i[15:0]}; 
					wd_o        <= inst_i[20:16];
					instvalid   <= `InstValid;
				end
				`EXE_SLTIU: begin
					wreg_o      <= `WriteEnable;
					aluop_o     <= `EXE_SLTU_OP;
					alusel_o    <= `EXE_RES_COMPARE;
					reg1_read_o <= 1'b1;
					reg2_read_o <= 1'b0;
					imm         <= {{16{inst_i[15]}}, inst_i[15:0]}; 
					wd_o        <= inst_i[20:16];
					instvalid   <= `InstValid;
				end
				`EXE_ADDI: begin
					wreg_o      <= `WriteEnable;
					aluop_o     <= `EXE_ADD_OP;
					alusel_o    <= `EXE_RES_ADD;
					reg1_read_o <= 1'b1;
					reg2_read_o <= 1'b0;
					imm         <= {{16{inst_i[15]}}, inst_i[15:0]}; 
					wd_o        <= inst_i[20:16];
					instvalid   <= `InstValid;
				end
				`EXE_ADDIU: begin
					wreg_o      <= `WriteEnable;
					aluop_o     <= `EXE_ADDU_OP;
					alusel_o    <= `EXE_RES_ADD;
					reg1_read_o <= 1'b1;
					reg2_read_o <= 1'b0;
					imm         <= {{16{inst_i[15]}}, inst_i[15:0]}; 
					wd_o        <= inst_i[20:16];
					instvalid   <= `InstValid;
				end
				`EXE_J: begin
					wreg_o      <= `WriteDisable;
					aluop_o     <= `EXE_NOP_OP;
					alusel_o    <= `EXE_RES_NOP;
					reg1_read_o <= 1'b0;
					reg2_read_o <= 1'b0;
					imm         <= `ZeroWord; 
					wd_o        <= inst_i[20:16];
					instvalid   <= `InstValid;
				end
				`EXE_JAL: begin
					wreg_o      <= `WriteEnable;
					aluop_o     <= `EXE_JAL_OP;
					alusel_o    <= `EXE_RES_JUMP;
					reg1_read_o <= 1'b0;
					reg2_read_o <= 1'b0;
					imm         <= `ZeroWord;
					wd_o		<= 5'b11111;
					instvalid   <= `InstValid;
				end
				default: begin 
					aluop_o     <= `EXE_NOP_OP;  
					alusel_o    <= `EXE_RES_NOP;  
					wd_o        <= inst_i[15:11];  
					wreg_o      <= `WriteDisable;  
					instvalid   <= `InstInvalid;      
					reg1_read_o <= 1'b0;  
					reg2_read_o <= 1'b0; 
					imm <= `ZeroWord;
				end  
			endcase          //case op 
		end
	end         //always  
	

/**************************************************************** 
***********         �ڶ��Σ�ȷ�����������Դ������1        ********* 
*****************************************************************/  
     
	always @ (*) begin  
		if(rst == `RstEnable) begin  
			reg1_o <= `ZeroWord;  
		end else if(reg1_read_o == 1'b1) begin  
			reg1_o <= reg1_data_i;   // Regfile���˿�1�����ֵ  
		end else if(reg1_read_o == 1'b0) begin  
			reg1_o <= imm;           // ������  
		end else begin  
			reg1_o <= `ZeroWord;  
		end
		if (op == `EXE_SPECIAL_INST && op3 == `EXE_JALR) begin
			reg1_o <= pc_plus_8;
		end else if (op == `EXE_JAL) begin
			reg1_o <= pc_plus_8;
		end
	end  
	
/**************************************************************** 
***********         �����Σ�ȷ�����������Դ������2        ********* 
*****************************************************************/  
	
	always @ (*) begin  
		if(rst == `RstEnable) begin  
			reg2_o <= `ZeroWord;  
		end else if(reg2_read_o == 1'b1) begin  
			reg2_o <= reg2_data_i;   // Regfile���˿�2�����ֵ  
		end else if(reg2_read_o == 1'b0) begin  
			reg2_o <= imm;           // ������  
		end else begin  
			reg2_o <= `ZeroWord;  
		end
		if (op == `EXE_SPECIAL_INST && op3 == `EXE_JALR) begin
			reg2_o <= `ZeroWord;
		end else if (op == `EXE_JAL) begin
			reg2_o <= `ZeroWord;
		end
	end
	
	always @ (*) begin
		if (op == `EXE_SPECIAL_INST) begin
			if (op3 == `EXE_JR || op3 == `EXE_JALR) begin
				branch_flag_o <= `Branch;
				branch_target_o <= reg1_data_i;
			end
		end else if (op == `EXE_J || op == `EXE_JAL) begin
			branch_flag_o <= `Branch;
			branch_target_o <= {pc_plus_4[31:28], inst_i[25:0],2'b00};
		end
	end
	
endmodule  
