`include "defines.v"

module mem(  
  
    input wire				rst,
      
    // 来自执行阶段的信息      
    input wire[`RegAddrBus]	wd_i,
    input wire				wreg_i,
    input wire[`RegBus]		wdata_i,
	
	input wire[`RegBus]		hi_i,  
    input wire[`RegBus]		lo_i,  
    input wire				whilo_i,  
      
    // 访存阶段的结果  
    output reg[`RegAddrBus]	wd_o,
    output reg				wreg_o,
    output reg[`RegBus]		wdata_o,
	
	output reg[`RegBus]		hi_o,  
    output reg[`RegBus]		lo_o,  
    output reg				whilo_o,
	
	input wire[`AluOpBus]	aluop_i,  
	input wire[`RegBus]		mem_addr_i,  
	input wire[`RegBus]		reg2_i,
	
	input wire[`RegBus]		mem_data_i,  
	output reg[`RegBus]		mem_addr_o,  
	output reg[`RegBus]		mem_data_o,  
	output reg				mem_we,  
	output reg[3:0]			mem_sel_o,  
	output reg				mem_ce_o
      
);  
  
  always @ (*) begin  
    if(rst == `RstEnable) begin  
      wd_o       <= `NOPRegAddr;  
      wreg_o     <= `WriteDisable;  
      wdata_o    <= `ZeroWord;  
      hi_o       <= `ZeroWord;  
      lo_o       <= `ZeroWord;  
      whilo_o    <= `WriteDisable;  
      mem_addr_o <= `ZeroWord;  
      mem_we     <= `WriteDisable;  
      mem_sel_o  <= 4'b0000;  
      mem_data_o <= `ZeroWord;  
      mem_ce_o   <= `ChipDisable;      
  end else begin  
      wd_o       <= wd_i;  
      wreg_o     <= wreg_i;  
      wdata_o    <= wdata_i;  
      hi_o       <= hi_i;  
      lo_o       <= lo_i;  
      whilo_o    <= whilo_i;  
      mem_we     <= `WriteDisable;  
      mem_addr_o <= `ZeroWord;  
      mem_sel_o  <= 4'b1111;  
      mem_ce_o   <= `ChipDisable;  
      case (aluop_i)  
        `EXE_LB_OP:     begin                  //lb指令  
           mem_addr_o <= mem_addr_i;  
           mem_we     <= `WriteDisable;  
           mem_ce_o   <= `ChipEnable;  
           case (mem_addr_i[1:0])  
             2'b00: begin  
               wdata_o   <= {{24{mem_data_i[31]}},mem_data_i[31:24]};  
               mem_sel_o <= 4'b1000;  
             end  
             2'b01: begin  
               wdata_o   <= {{24{mem_data_i[23]}},mem_data_i[23:16]};  
               mem_sel_o <= 4'b0100;  
             end  
             2'b10: begin  
               wdata_o   <= {{24{mem_data_i[15]}},mem_data_i[15:8]};  
               mem_sel_o <= 4'b0010;  
             end  
             2'b11: begin  
               wdata_o   <= {{24{mem_data_i[7]}},mem_data_i[7:0]};  
               mem_sel_o <= 4'b0001;  
             end  
             default:   begin  
               wdata_o   <= `ZeroWord;  
             end  
           endcase  
        end 
       `EXE_LW_OP:      begin                   //lw指令  
          mem_addr_o <= mem_addr_i;  
          mem_we     <= `WriteDisable;  
          wdata_o    <= mem_data_i;  
          mem_sel_o  <= 4'b1111;  
          mem_ce_o   <= `ChipEnable;  
       end 
      `EXE_SB_OP:       begin             //sb指令  
          mem_addr_o <= mem_addr_i;  
          mem_we     <= `WriteEnable;  
          mem_data_o <= {reg2_i[7:0],reg2_i[7:0],  
                          reg2_i[7:0],reg2_i[7:0]};  
          mem_ce_o   <= `ChipEnable;  
          case (mem_addr_i[1:0])  
            2'b00: begin  
               mem_sel_o <= 4'b1000;  
            end  
            2'b01: begin  
               mem_sel_o <= 4'b0100;  
            end  
            2'b10: begin  
               mem_sel_o <= 4'b0010;  
            end  
            2'b11: begin  
               mem_sel_o <= 4'b0001;   
            end  
            default: begin  
               mem_sel_o <= 4'b0000;  
            end  
          endcase  
       end
      `EXE_SW_OP:       begin             //sw指令  
          mem_addr_o <= mem_addr_i;  
          mem_we     <= `WriteEnable;  
          mem_data_o <= reg2_i;  
          mem_sel_o  <= 4'b1111;  
          mem_ce_o   <= `ChipEnable;  
       end 
      default:      begin  
       //do nothing  
      end  
    endcase  
  end  
 end  
  
endmodule  
