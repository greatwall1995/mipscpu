`include "defines.v"

// bubble checker
// can be changed to pipeline

module bc(
	
	input wire clk,
	input wire rst,
	
	input wire read1,
	input wire[`RegAddrBus] addr1,
	input wire read2,
	input wire[`RegAddrBus] addr2,
	
	input wire[`RegAddrBus] addr_o,
	
	output reg bbl
);
	
	reg[`RegAddrBus] reg1, reg2;

	reg test;
	
	initial begin
		reg1 <= `NOPRegAddr;
		reg2 <= `NOPRegAddr;
		bbl <= `BblDisable;
	end
	
	always @ (posedge clk) begin
		test <= 1'b1;
	end
	
	always @ (negedge clk) begin
		test <= 1'b0;
		if (rst != `RstEnable) begin
			if (read1 != 1'b0 && addr1 != `NOPRegAddr
				&& (addr1 == reg1 || addr1 == reg2)) begin
				bbl <= `BblEnable;
				reg1 <= `NOPRegAddr;
			end else if (read2 != 1'b0 && addr2 != `NOPRegAddr
				&& (addr2 == reg1 || addr2 == reg2)) begin
				bbl <= `BblEnable;
				reg1 <= `NOPRegAddr;
			end else begin
				bbl <= `BblDisable;
				reg1 <= addr_o;
			end
			reg2 <= reg1;
		end else begin
			reg1 <= `NOPRegAddr;
			reg2 <= `NOPRegAddr;
			bbl <= `BblDisable;
		end
	end

endmodule