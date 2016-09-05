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
	
	mips mips0(
		.clk(clk),
		.rst(rst),
		.bbl(bbl),
		.rom_addr_o(inst_addr),
		.rom_data_i(inst),
		.rom_ce_o(rom_ce),
		.exp_read1(exp_read1),
		.exp_addr1(exp_addr1),
		.exp_read2(exp_read2),
		.exp_addr2(exp_addr2),
		.tar_addr(tar_addr)
	);
	
	inst_rom inst_rom0(
		.ce(rom_ce),
		.addr(inst_addr),
		.inst(inst)
	);
	
	bc bc0(
		.clk(clk),
		.rst(rst),
		.read1(exp_read1),
		.addr1(exp_addr1),
		.read2(exp_read2),
		.addr2(exp_addr2),
		.addr_o(tar_addr),
		.bbl(bbl)
	);

endmodule