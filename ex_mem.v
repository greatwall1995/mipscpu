`include "defines.v"

module ex_mem(  
  
    input wire					clk,  
    input wire					rst,
      
    // 来自执行阶段的信息      
    input wire[`RegAddrBus]       ex_wd,  
    input wire                    ex_wreg,  
    input wire[`RegBus]           ex_wdata,
	
	input wire[`RegBus]           ex_hi,  
    input wire[`RegBus]           ex_lo,  
    input wire                    ex_whilo, 
	
	input wire[`AluOpBus]			ex_aluop,  
	input wire[`RegBus]				ex_mem_addr,  
	input wire[`RegBus]				ex_reg2,    
      
    // 送到访存阶段的信息  
    output reg[`RegAddrBus]       mem_wd,  
    output reg                    mem_wreg,  
    output reg[`RegBus]           mem_wdata,
	
	output reg[`RegBus]           mem_hi,  
    output reg[`RegBus]           mem_lo,  
    output reg                    mem_whilo,
	
	output reg[`AluOpBus]			mem_aluop,  
	output reg[`RegBus]			mem_mem_addr,  
	output reg[`RegBus]			mem_reg2
);  
  
    always @ (posedge clk) begin  
      if(rst == `RstEnable) begin  
        mem_wd    <= `NOPRegAddr;  
        mem_wreg  <= `WriteDisable;  
        mem_wdata <= `ZeroWord;  
		mem_hi    <= `ZeroWord;  
        mem_lo    <= `ZeroWord;  
        mem_whilo <= `WriteDisable;   
		mem_aluop		<= `EXE_NOP_OP;
      end else begin  
        mem_wd			<= ex_wd;  
        mem_wreg		<= ex_wreg;  
        mem_wdata		<= ex_wdata;
		mem_hi			<= ex_hi;  
        mem_lo			<= ex_lo;  
        mem_whilo		<= ex_whilo;  
		mem_aluop		<= ex_aluop;
        mem_mem_addr	<= ex_mem_addr;
		mem_reg2		<= ex_reg2;
      end      
    end        
              
endmodule  