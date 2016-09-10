`include "defines.v"

module sopc(
	input wire clk,
	input wire rst
);

	wire[`InstAddrBus] inst_addr;
	wire[`InstBus] inst;
	wire rom_ce;
	wire exp_read1;
	wire[`RegAddrBus] exp_addr1;
	wire exp_read2;
	wire[`RegAddrBus] exp_addr2;
	wire[`RegAddrBus] tar_addr;
	wire bbl;
	wire stop;
	
	wire[`RegBus]		mem_data_i;
	wire[`RegBus]		mem_addr_o;
	wire[`RegBus]		mem_data_o;
	wire				mem_we_o; 
	wire[3:0]			mem_sel_o; 
	wire				mem_ce_o;
	
	mips mips0(
		.clk(clk),
		.rst(rst),
		.bbl(bbl),
		.rom_addr_o(inst_addr),
		.rom_data_i(inst),
		.rom_ce_o(rom_ce),
		.mem_data_i(mem_data_i),
		.mem_addr_o(mem_addr_o),
		.mem_data_o(mem_data_o),
		.mem_we_o(mem_we_o),
		.mem_sel_o(mem_sel_o),
		.mem_ce_o(mem_ce_o),
		.exp_read1(exp_read1),
		.exp_addr1(exp_addr1),
		.exp_read2(exp_read2),
		.exp_addr2(exp_addr2),
		.tar_addr(tar_addr),
		.stop(stop)
	);
	
	inst_rom inst_rom0(
		.ce(rom_ce),
		.addr(inst_addr),
		.inst(inst)
	);
	
	bc bc0(
		.clk(clk),
		.rst(rst),
		.stop(stop),
		.read1(exp_read1),
		.addr1(exp_addr1),
		.read2(exp_read2),
		.addr2(exp_addr2),
		.addr_o(tar_addr),
		.bbl(bbl)
	);
	
	data_ram data_ram0(
		.clk(clk),  
		.ce(mem_ce_o),
		.we(mem_we_o),
		.addr(mem_addr_o),
		.sel(mem_sel_o),
		.data_i(mem_data_o),
		.data_o(mem_data_i)
	);

endmodule