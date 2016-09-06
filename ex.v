`include "defines.v"

module ex(  
  
    input wire             rst,
      
    // 译码阶段送到执行阶段的信息  
    input wire[`AluOpBus]         aluop_i,  
    input wire[`AluSelBus]        alusel_i,  
    input wire[`RegBus]           reg1_i,  
    input wire[`RegBus]           reg2_i,  
    input wire[`RegAddrBus]       wd_i,  
    input wire                    wreg_i,  
  
    // 执行的结果  
    output reg[`RegAddrBus]       wd_o,  
    output reg                    wreg_o,  
    output reg[`RegBus]           wdata_o  
      
);  

	// 保存逻辑运算的结果  
	wire[`RegBus] logicres;
	wire[`RegBus] shiftres;
	wire[`RegBus] compareres;
	
	ex_logic ex_logic0(
		.rst(rst),
		.aluop_i(aluop_i), 
		.alusel_i(alusel_i),
		.reg1_i(reg1_i),
		.reg2_i(reg2_i),
		.wdata_o(logicres)
	);
	
	ex_shift ex_shift0(
		.rst(rst),
		.aluop_i(aluop_i), 
		.alusel_i(alusel_i),
		.reg1_i(reg1_i),
		.reg2_i(reg2_i),
		.wdata_o(shiftres) 
	);
	
	ex_compare ex_compare0(
		.rst(rst),
		.aluop_i(aluop_i), 
		.alusel_i(alusel_i),
		.reg1_i(reg1_i),
		.reg2_i(reg2_i),
		.wdata_o(compareres) 
	);

	always @ (*) begin
		// if (rst == RstEnable) begin
		wd_o   <= wd_i;             // wd_o等于wd_i，要写的目的寄存器地址  
		wreg_o <= wreg_i;           // wreg_o等于wreg_i，表示是否要写目的寄存器  
		wdata_o <= logicres | shiftres | compareres;
	end
endmodule  