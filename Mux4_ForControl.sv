module Mux4_ForControl
	(
	input Sel,
	// Control signals for for EX block
	input [1:0] i_Mux4_ALUOp, 
	input i_Mux4_ALUSrc, 
	 // Control signals for for M block 
	input i_Mux4_branch_out,
	input i_Mux4_MemRead, 
	input i_Mux4_MemWrite,
	 // Control signals for for WB block 
	input i_Mux4_RegWrite,
	input i_Mux4_MemtoReg, 
	
	output reg [1:0] o_Mux4_ALUOp, 
	output reg o_Mux4_ALUSrc, 
	 // Control signals for for M block 
	output reg o_Mux4_branch_out,
	output reg o_Mux4_MemRead, 
	output reg o_Mux4_MemWrite,
	 // Control signals for for WB block 
	output reg o_Mux4_RegWrite,
	output reg o_Mux4_MemtoReg
	);		
	
	
	assign o_Mux4_ALUOp = (Sel == 1'b1) ? 2'b0: i_Mux4_ALUOp;
	assign o_Mux4_ALUSrc = (Sel == 1'b1) ? 1'b0: i_Mux4_ALUSrc;
	assign o_Mux4_branch_out = (Sel == 1'b1) ? 1'b0: i_Mux4_branch_out;
	assign o_Mux4_MemRead = (Sel == 1'b1) ? 1'b0: i_Mux4_MemRead;
	assign o_Mux4_MemWrite = (Sel == 1'b1) ? 1'b0: i_Mux4_MemWrite;
	assign o_Mux4_RegWrite = (Sel == 1'b1) ? 1'b0: i_Mux4_RegWrite;
	assign o_Mux4_MemtoReg = (Sel == 1'b1) ? 1'b0: i_Mux4_MemtoReg;
endmodule 