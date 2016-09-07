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
	
	// HILO模块给出的HI、LO寄存器的值  
    input wire[`RegBus]           hi_i,  
    input wire[`RegBus]           lo_i,  
  
    // 回写阶段的指令是否要写HI、LO，用于检测HI、LO寄存器带来的数据相关问题  
    input wire[`RegBus]           wb_hi_i,  
    input wire[`RegBus]           wb_lo_i,  
    input wire                    wb_whilo_i,  
      
    // 访存阶段的指令是否要写HI、LO，用于检测HI、LO寄存器带来的数据相关问题  
    input wire[`RegBus]           mem_hi_i,  
    input wire[`RegBus]           mem_lo_i,  
    input wire                    mem_whilo_i,
  
    // 执行的结果  
    output reg[`RegAddrBus]       wd_o,  
    output reg                    wreg_o,  
    output reg[`RegBus]           wdata_o,
	
    // 处于执行阶段的指令对HI、LO寄存器的写操作请求  
    output wire[`RegBus]           hi_o,  
    output wire[`RegBus]           lo_o,  
    output wire                    whilo_o
      
);  

	// 保存逻辑运算的结果  
	wire[`RegBus]	logicres;
	wire[`RegBus]	shiftres;
	wire[`RegBus]	compareres;
	wire[`RegBus]	addres;
	wire[`RegBus]	moveres;
	wire			wreg_o_add;
	wire			wreg_o_move;
	
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
	
	ex_add ex_add0(
		.rst(rst),
		.aluop_i(aluop_i), 
		.alusel_i(alusel_i),
		.reg1_i(reg1_i),
		.reg2_i(reg2_i),
		.wreg_o(wreg_o_add),
		.wdata_o(addres)
	);
	
	ex_move ex_move0(
		.rst(rst),
		.aluop_i(aluop_i), 
		.alusel_i(alusel_i),
		.reg1_i(reg1_i),
		.reg2_i(reg2_i),
		
		.hi_i(hi_i),
		.lo_i(lo_i),
		
		.wb_hi_i(wb_hi_i),
		.wb_lo_i(wb_lo_i),
		.wb_whilo_i(wb_whilo_i),
		
		.mem_hi_i(mem_hi_i),
		.mem_lo_i(mem_lo_i),
		.mem_whilo_i(mem_whilo_i),
		
		.wreg_o(wreg_o_move),
		.wdata_o(moveres),
		
		.hi_o(hi_o),
		.lo_o(lo_o),
		.whilo_o(whilo_o)
	);

	always @ (*) begin
		// if (rst == RstEnable) begin
		wd_o   <= wd_i;             // wd_o等于wd_i，要写的目的寄存器地址  
		if (alusel_i == `EXE_RES_ADD) begin
			wreg_o <= wreg_i & wreg_o_add;
		end else if (alusel_i == `EXE_RES_MOVE) begin
			wreg_o <= wreg_i & wreg_o_move;
		end else begin
			wreg_o <= wreg_i;
		end
		wdata_o <= logicres | shiftres | compareres | addres
				| moveres;
	end
endmodule  