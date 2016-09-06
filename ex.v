`include "defines.v"

module ex(  
  
    input wire             rst,
      
    // ����׶��͵�ִ�н׶ε���Ϣ  
    input wire[`AluOpBus]         aluop_i,  
    input wire[`AluSelBus]        alusel_i,  
    input wire[`RegBus]           reg1_i,  
    input wire[`RegBus]           reg2_i,  
    input wire[`RegAddrBus]       wd_i,  
    input wire                    wreg_i,  
  
    // ִ�еĽ��  
    output reg[`RegAddrBus]       wd_o,  
    output reg                    wreg_o,  
    output reg[`RegBus]           wdata_o  
      
);  

	// �����߼�����Ľ��  
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
		wd_o   <= wd_i;             // wd_o����wd_i��Ҫд��Ŀ�ļĴ�����ַ  
		wreg_o <= wreg_i;           // wreg_o����wreg_i����ʾ�Ƿ�ҪдĿ�ļĴ���  
		wdata_o <= logicres | shiftres | compareres;
	end
endmodule  