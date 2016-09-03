`timescale 1ns/1ps
`include "defines.v"

module run();

	reg rst;
	reg clock;
	
	reg[`InstBus] inst_mem[0:`InstMemNum - 1];
	
	initial begin
		clock = 1'b0;
		forever #10 clock = ~clock; 
	end
	
	initial begin
		rst = `RstEnable;
		#195 rst= `RstDisable;
		#1000 $stop;
	end

	sopc sopc0(
		.clk(clock),
		.rst(rst)   
	);

endmodule  