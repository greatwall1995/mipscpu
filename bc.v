`include "defines.v"

// bubble checker
// can be changed to pipeline

module bc(
	
	//input wire clk,
	input wire rst,
	
	input wire[`RegAddrBus] addr,
	
	output reg bbl
);
	
	reg[`RegAddrBus] reg1, reg2;
	
	initial begin
		reg1 <= `NOPRegAddr;
		reg2 <= `NOPRegAddr;
	end
	
	always @ (*) begin
		if (rst == `RstEnable) begin
			bbl = `BblDisable;
		end else begin
			if (addr == NOPRegAddr) begin
				bbl = `BblDisable;
			end else if (addr == reg1 || addr == reg2) begin
				bbl = `BblEnable;
			end else begin
				bbl = `BblDisable;
			end
		end
		reg2 = reg1;
		if (bbl == `BblEnable) reg1 = `NOPRegAddr;
		else reg1 = addr;
	end

endmodule