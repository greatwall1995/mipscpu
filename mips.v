`include "defines.v"

module mips(  
  
    input wire					clk,  
    input wire					rst, 
	input wire					bbl,
      
    input wire[`RegBus]			rom_data_i,
    output wire[`RegBus]		rom_addr_o,  
    output wire					rom_ce_o,
	
	input wire[`RegBus]			mem_data_i,  
	output wire[`RegBus]		mem_addr_o,  
	output wire[`RegBus]		mem_data_o,  
	output wire					mem_we_o,  
	output wire[3:0]			mem_sel_o,  
	output wire					mem_ce_o,  
	
	output wire					exp_read1,
	output wire[`RegAddrBus]	exp_addr1,
	output wire					exp_read2,
	output wire[`RegAddrBus]	exp_addr2,
	output wire[`RegAddrBus]	tar_addr,
	output wire					stop
);
  
       // 连接IF/ID模块与译码阶段ID模块的变量  
    wire[`InstAddrBus]	pc;  
    wire[`InstAddrBus]	id_pc_i;  
    wire[`InstBus]		id_inst_i;  
	wire				branch_flag;
	wire[`InstAddrBus]	branch_target;
      
    // 连接译码阶段ID模块输出与ID/EX模块的输入的变量  
    wire[`AluOpBus]		id_aluop_o;  
    wire[`AluSelBus]	id_alusel_o;  
    wire[`RegBus]		id_reg1_o;  
    wire[`RegBus]		id_reg2_o;  
    wire 				id_wreg_o;  
    wire[`RegAddrBus]	id_wd_o;  
      
    // 连接ID/EX模块输出与执行阶段EX模块的输入的变量  
    wire[`AluOpBus]    ex_aluop_i;  
    wire[`AluSelBus]   ex_alusel_i;  
    wire[`RegBus]      ex_reg1_i;  
    wire[`RegBus]      ex_reg2_i;  
    wire               ex_wreg_i;  
    wire[`RegAddrBus]  ex_wd_i;  
      
    // 连接执行阶段EX模块的输出与EX/MEM模块的输入的变量  
    wire				ex_wreg_o;  
    wire[`RegAddrBus]	ex_wd_o;  
    wire[`RegBus]		ex_wdata_o;
	wire[`RegBus]		ex_hi_o;
	wire[`RegBus]		ex_lo_o;
	wire				ex_whilo_o;  
	wire				ex_stop;
	wire[`AluOpBus]		ex_aluop_o;
	wire[`RegBus]		ex_mem_addr_o;
	wire[`RegBus]		ex_reg2_o;
  
    // 连接EX/MEM模块的输出与访存阶段MEM模块的输入的变量  
    wire				mem_wreg_i;  
    wire[`RegAddrBus]	mem_wd_i;  
    wire[`RegBus]		mem_wdata_i;  
	wire[`RegBus]		mem_hi_i;
	wire[`RegBus]		mem_lo_i;
	wire				mem_whilo_i;
	
	wire[`AluOpBus]		mem_aluop_i;
	wire[`RegBus]		mem_mem_addr_i;
	wire[`RegBus]		mem_reg2_i;	
  
    // 连接访存阶段MEM模块的输出与MEM/WB模块的输入的变量  
    wire				mem_wreg_o;  
    wire[`RegAddrBus]	mem_wd_o;  
    wire[`RegBus]		mem_wdata_o; 
	wire[`RegBus]		mem_hi_o;
	wire[`RegBus]		mem_lo_o;
	wire				mem_whilo_o;	 
      
    // 连接MEM/WB模块的输出与回写阶段的输入的变量   
    wire				wb_wreg_i;  
    wire[`RegAddrBus]	wb_wd_i;  
    wire[`RegBus]		wb_wdata_i;
	wire[`RegBus]		wb_hi_i;
	wire[`RegBus]		wb_lo_i;
	wire				wb_whilo_i;  
      
    // 连接译码阶段ID模块与通用寄存器Regfile模块的变量  
    wire               reg1_read;  
    wire               reg2_read;  
    wire[`RegBus]      reg1_data;  
    wire[`RegBus]      reg2_data;  
    wire[`RegAddrBus]  reg1_addr;  
    wire[`RegAddrBus]  reg2_addr;
	   
	//连接执行阶段与hilo模块的输出，读取HI、LO寄存器
	wire[`RegBus]	hi;
	wire[`RegBus]	lo;
	
	assign stop = ex_stop;
    
  // pc_reg例化  
    pc_reg pc_reg0(  
		.clk(clk),
		.rst(rst),
		.bbl(bbl),
		.branch_flag_i(branch_flag),
		.branch_target_i(branch_target),
		.pc(pc),
		.ce(rom_ce_o)  
    );  
      
	assign rom_addr_o = pc;   // 指令存储器的输入地址就是pc的值  
  
	// IF/ID模块例化  
    if_id if_id0(
        .clk(clk),
		.rst(rst),
		.bbl(bbl),
		.if_pc(pc),
        .if_inst(rom_data_i),
		.branch_flag_i(branch_flag),
		.branch_target_i(branch_target),
		.id_pc(id_pc_i),
        .id_inst(id_inst_i)
    );  
      
    // 译码阶段ID模块例化  
    id id0(  
        .rst(rst),
		.pc_i(id_pc_i),
		.inst_i(id_inst_i),  
                
        // 来自Regfile模块的输入  
        .reg1_data_i(reg1_data),
		.reg2_data_i(reg2_data),  
  
        // 送到regfile模块的信息  
        .reg1_read_o(reg1_read),
		.reg2_read_o(reg2_read),        
        .reg1_addr_o(reg1_addr),
		.reg2_addr_o(reg2_addr),   
        
        // 送到ID/EX模块的信息  
        .aluop_o(id_aluop_o),
		.alusel_o(id_alusel_o),  
        .reg1_o(id_reg1_o),
		.reg2_o(id_reg2_o),  
        .wd_o(id_wd_o),
		.wreg_o(id_wreg_o),
		.branch_flag_o(branch_flag),
		.branch_target_o(branch_target)
    ); 
	
	assign exp_read1 = reg1_read;
	assign exp_addr1 = reg1_addr;
	assign exp_read2 = reg2_read;
	assign exp_addr2 = reg2_addr;
	assign tar_addr = id_wd_o;
  
       // 通用寄存器Regfile模块例化  
    regfile regfile0(  
        .clk (clk),
		.rst (rst),  
        .we(wb_wreg_i),
		.waddr(wb_wd_i),  
        .wdata(wb_wdata_i),
		.re1(reg1_read),  
        .raddr1(reg1_addr),
		.rdata1(reg1_data),  
        .re2(reg2_read),
		.raddr2(reg2_addr),  
        .rdata2(reg2_data)  
    );
	
	hilo_reg hilo_reg0(
		.clk(clk),
		.rst(rst),
	
		//写端口
		.we(wb_whilo_i),
		.hi_i(wb_hi_i),
		.lo_i(wb_lo_i),
	
		//读端口1
		.hi_o(hi),
		.lo_o(lo)	
	);
  
    // ID/EX模块例化  
    id_ex id_ex0(  
        .clk(clk),
		.rst(rst),
		.bbl(bbl), 
          
        // 从译码阶段ID模块传递过来的信息  
        .id_aluop(id_aluop_o),
		.id_alusel(id_alusel_o),  
        .id_reg1(id_reg1_o),
		.id_reg2(id_reg2_o),  
        .id_wd(id_wd_o),
		.id_wreg(id_wreg_o),  
      
        // 传递到执行阶段EX模块的信息  
        .ex_aluop(ex_aluop_i),
		.ex_alusel(ex_alusel_i),  
        .ex_reg1(ex_reg1_i),
		.ex_reg2(ex_reg2_i),  
        .ex_wd(ex_wd_i),
		.ex_wreg(ex_wreg_i)  
    );  
      
    // EX模块例化  
    ex ex0(  
        .rst(rst),
		.clk(clk),
      
        // 从ID/EX模块传递过来的的信息  
        .aluop_i(ex_aluop_i),
		.alusel_i(ex_alusel_i),  
        .reg1_i(ex_reg1_i),
		.reg2_i(ex_reg2_i),  
        .wd_i(ex_wd_i),
		.wreg_i(ex_wreg_i),
		
		.hi_i(hi),
		.lo_i(lo),

		.wb_hi_i(wb_hi_i),
		.wb_lo_i(wb_lo_i),
		.wb_whilo_i(wb_whilo_i),
		.mem_hi_i(mem_hi_o),
		.mem_lo_i(mem_lo_o),
		.mem_whilo_i(mem_whilo_o),
        
           //输出到EX/MEM模块的信息  
        .wd_o(ex_wd_o),
		.wreg_o(ex_wreg_o),  
        .wdata_o(ex_wdata_o),
		
		.hi_o(ex_hi_o),
		.lo_o(ex_lo_o),
		.whilo_o(ex_whilo_o),
		
		.stop(ex_stop),
		.aluop_o(ex_aluop_o),
		.mem_addr_o(ex_mem_addr_o),
		.reg2_o(ex_reg2_o)
    );
  
    // EX/MEM模块例化  
    ex_mem ex_mem0(  
        .clk(clk),
		.rst(rst),
        
        // 来自执行阶段EX模块的信息  
        .ex_wd(ex_wd_o),
		.ex_wreg(ex_wreg_o),  
        .ex_wdata(ex_wdata_o),  
		
		
		.ex_hi(ex_hi_o),
		.ex_lo(ex_lo_o),
		.ex_whilo(ex_whilo_o),
		
		.ex_aluop(ex_aluop_o),
		.ex_mem_addr(ex_mem_addr_o),
		.ex_reg2(ex_reg2_o),
      
        // 送到访存阶段MEM模块的信息  
        .mem_wd(mem_wd_i),
		.mem_wreg(mem_wreg_i),  
        .mem_wdata(mem_wdata_i),
		
		
		.mem_hi(mem_hi_i),
		.mem_lo(mem_lo_i),
		.mem_whilo(mem_whilo_i),
		
		.mem_aluop(mem_aluop_i),
		.mem_mem_addr(mem_mem_addr_i),
		.mem_reg2(mem_reg2_i)
    );  
      
       // MEM模块例化  
    mem mem0(  
        .rst(rst),  
      
        // 来自EX/MEM模块的信息      
        .wd_i(mem_wd_i),
		.wreg_i(mem_wreg_i),  
        .wdata_i(mem_wdata_i),
		
		.hi_i(mem_hi_i),
		.lo_i(mem_lo_i),
		.whilo_i(mem_whilo_i),
		
		.mem_data_i(mem_data_i),  
        
        // 送到MEM/WB模块的信息  
        .wd_o(mem_wd_o),
		.wreg_o(mem_wreg_o),  
        .wdata_o(mem_wdata_o),
		
		.hi_o(mem_hi_o),
		.lo_o(mem_lo_o),
		.whilo_o(mem_whilo_o),
		
		.aluop_i(mem_aluop_i),
		.mem_addr_i(mem_mem_addr_i),
		.reg2_i(mem_reg2_i),
  
		.mem_addr_o(mem_addr_o),  
		.mem_we(mem_we_o),  
		.mem_sel_o(mem_sel_o),  
		.mem_data_o(mem_data_o),  
		.mem_ce_o(mem_ce_o)
    );  
  
	// MEM/WB模块例化  
	mem_wb mem_wb0(  
		.clk(clk),
		.rst(rst),
	
		// 来自访存阶段MEM模块的信息     
		.mem_wd(mem_wd_o),
		.mem_wreg(mem_wreg_o),  
		.mem_wdata(mem_wdata_o), 
		
		.mem_hi(mem_hi_o),
		.mem_lo(mem_lo_o),
		.mem_whilo(mem_whilo_o),
	
		// 送到回写阶段的信息  
		.wb_wd(wb_wd_i),
		.wb_wreg(wb_wreg_i),
		.wb_wdata(wb_wdata_i),
		
		.wb_hi(wb_hi_i),
		.wb_lo(wb_lo_i),
		.wb_whilo(wb_whilo_i)
	);  
  
endmodule  