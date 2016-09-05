`include "defines.v"

module id(  
	input wire rst,
	input wire bbl,
	input wire[`InstAddrBus] pc_i,  
	input wire[`InstBus] inst_i,  
		
	// 读取的Regfile的值  
	input wire[`RegBus]           reg1_data_i,  
	input wire[`RegBus]           reg2_data_i,  
	
	// 输出到Regfile的信息  
	output reg                    reg1_read_o,  
	output reg                    reg2_read_o,       
	output reg[`RegAddrBus]       reg1_addr_o,  
	output reg[`RegAddrBus]       reg2_addr_o,   
	
	// 送到执行阶段的信息  
	output reg[`AluOpBus]         aluop_o,  
	output reg[`AluSelBus]        alusel_o,  
	output reg[`RegBus]           reg1_o,  
	output reg[`RegBus]           reg2_o,  
	output reg[`RegAddrBus]       wd_o,  
	output reg                    wreg_o
);
    
	// 取得指令的指令码，功能码  
	// 对于ori指令只需通过判断第26-31bit的值，即可判断是否是ori指令  
	wire[5:0] op  = inst_i[31:26];  
	wire[4:0] op2 = inst_i[10:6];  
	wire[5:0] op3 = inst_i[5:0];  
	wire[4:0] op4 = inst_i[20:16];  
	
	// 保存指令执行需要的立即数  
	reg[`RegBus] imm;
	reg[`RegAddrBus] reg1;
	reg[`RegAddrBus] reg2;
	
	// 指示指令是否有效  
	reg instvalid;  			// ?????????????????????
	
	initial begin
		reg1 <= `RegNumLog2'h0;
		reg2 <= `RegNumLog2'h0;
	end
	
/**************************************************************** 
***********             第一段：对指令进行译码             ********* 
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
		end else begin  
			aluop_o     <= `EXE_NOP_OP;  
			alusel_o    <= `EXE_RES_NOP;  
			wd_o        <= inst_i[15:11];  
			wreg_o      <= `WriteDisable;  
			instvalid   <= `InstInvalid;      
			reg1_read_o <= 1'b0;  
			reg2_read_o <= 1'b0;  
			reg1_addr_o <= inst_i[25:21];  // 默认通过Regfile读端口1读取的寄存器地址  
			reg2_addr_o <= inst_i[20:16];  // 默认通过Regfile读端口2读取的寄存器地址  
			imm <= `ZeroWord;
		
			case (op)
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
				default: begin  
				end  
			endcase          //case op 
		end
	end         //always  
	

/**************************************************************** 
***********         第二段：确定进行运算的源操作数1        ********* 
*****************************************************************/  
     
	always @ (*) begin  
		if(rst == `RstEnable) begin  
			reg1_o <= `ZeroWord;  
		end else if(reg1_read_o == 1'b1) begin  
			reg1_o <= reg1_data_i;   // Regfile读端口1的输出值  
		end else if(reg1_read_o == 1'b0) begin  
			reg1_o <= imm;           // 立即数  
		end else begin  
			reg1_o <= `ZeroWord;  
		end  
	end  
	
/**************************************************************** 
***********         第三段：确定进行运算的源操作数2        ********* 
*****************************************************************/  
	
	always @ (*) begin  
		if(rst == `RstEnable) begin  
			reg2_o <= `ZeroWord;  
		end else if(reg2_read_o == 1'b1) begin  
			reg2_o <= reg2_data_i;   // Regfile读端口2的输出值  
		end else if(reg2_read_o == 1'b0) begin  
			reg2_o <= imm;           // 立即数  
		end else begin  
			reg2_o <= `ZeroWord;  
		end  
	end  
	
endmodule  
