`include "defines.v"

// bubble checker
// can be changed to pipeline
// bug: addr_o can not be written

module bc(
	
	input wire				clk,
	input wire				rst,
	input wire				stop,
	
	input wire				read1,
	input wire[`RegAddrBus]	addr1,
	input wire				read2,
	input wire[`RegAddrBus]	addr2,
	
	input wire[`RegAddrBus]	addr_o,
	
	
	output reg				bbl
);
	
	reg[`RegAddrBus] reg1, reg2;
	
	initial begin
		reg1 <= `NOPRegAddr;
		reg2 <= `NOPRegAddr;
		bbl <= `BblDisable;
	end
	
	always @ (negedge clk) begin
		if (rst == `RstEnable) begin
			reg1 <= `NOPRegAddr;
			reg2 <= `NOPRegAddr;
			bbl <= `BblDisable;
		end else begin
			if (stop == `Stop) begin
				bbl <= `BblEnable;
			end else begin
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
			end
		end
	end

endmodule