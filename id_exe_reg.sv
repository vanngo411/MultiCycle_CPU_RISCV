module id_exe_reg(
    input wire i_clk, i_reset,
    // Control signals from ID stage
	 // Control signals for for EX block
	 input wire [1:0] i_id_ex_ALUOp, 
	 input wire i_id_ex_ALUSrc, 
	 // Control signals for for M block 
	 input wire i_id_ex_Branch,
	 input wire i_id_ex_MemRead, 
	 input wire i_id_ex_MemWrite,
	 // Control signals for for WB block 
	 input wire i_id_ex_RegWrite,
	 input wire i_id_ex_MemToReg, 
	 // Program counter
	 input wire [31:0] i_id_ex_PC,
    // Data from ID stage 		 
	 input wire [31:0] i_id_ex_Read_data1, 
	 input wire [31:0] i_id_ex_Read_data2,
	 input wire [4:0] i_id_ex_Rs1,
	 input wire [4:0] i_id_ex_Rs2,
    input wire [4:0] i_id_ex_Rd,
	 input wire [31:0] i_id_ex_im_gen, 
	 input wire [31:0] i_id_ex_to_ALUControl,
    // Control signals out of EX stage
	 // Control signals for for EX block
	 output reg [1:0] o_id_ex_ALUOp, 
	 output reg o_id_ex_ALUSrc, 
	 // Control signals for for M block 
	 output reg o_id_ex_Branch,
	 output reg o_id_ex_MemRead, 
	 output reg o_id_ex_MemWrite,
	 // Control signals for for WB block 
	 output reg o_id_ex_RegWrite,
	 output reg o_id_ex_MemToReg,
	 // Program counter
	 output reg [31:0] o_id_ex_PC,
    // Data from ID stage 		 
	 output reg [31:0] o_id_ex_Read_data1, 
	 output reg [31:0] o_id_ex_Read_data2,
	 output reg [4:0] o_id_ex_Rs1,
	 output reg [4:0] o_id_ex_Rs2,
    output reg [4:0] o_id_ex_Rd,
	 output reg [31:0] o_id_ex_im_gen,
	 output reg [31:0] o_id_ex_to_ALUControl
);

    always @(posedge i_clk or posedge i_reset)
    begin
        if (i_reset)
        begin
				o_id_ex_ALUOp <= 2'b00;
				o_id_ex_ALUSrc <= 0;
				// Control signals for for M block 
				o_id_ex_Branch <= 0;
				o_id_ex_MemRead <= 0;
				o_id_ex_MemWrite <= 0;
				// Control signals for for WB block 
				o_id_ex_RegWrite <= 0;
				o_id_ex_MemToReg <= 0;				
				// Program counter
				o_id_ex_PC <= 0;
				// Data from ID stage
				o_id_ex_Read_data1 <= 0;
				o_id_ex_Read_data2 <= 0;
				o_id_ex_Rs1 <= 0;
				o_id_ex_Rs2 <= 0;
				o_id_ex_Rd <= 0;
				o_id_ex_im_gen <= 0;
				o_id_ex_to_ALUControl <= 0;
        end

        else
        begin
				o_id_ex_ALUOp <= i_id_ex_ALUOp;
				o_id_ex_ALUSrc <= i_id_ex_ALUSrc;
				// Control signals for for M block 
				o_id_ex_Branch <= i_id_ex_Branch;
				o_id_ex_MemRead <= i_id_ex_MemRead;
				o_id_ex_MemWrite <= i_id_ex_MemWrite;
				// Control signals for for WB block 
				o_id_ex_RegWrite <= i_id_ex_RegWrite;
				o_id_ex_MemToReg <= i_id_ex_MemToReg;
				// Program counter
				o_id_ex_PC <= i_id_ex_PC;
				// Data from ID stage 		 
				o_id_ex_Read_data1 <= i_id_ex_Read_data1;
				o_id_ex_Read_data2 <= i_id_ex_Read_data2;
				o_id_ex_Rs1 <= i_id_ex_Rs1;
				o_id_ex_Rs2 <= i_id_ex_Rs2;
				o_id_ex_Rd <= i_id_ex_Rd;
				o_id_ex_im_gen <= i_id_ex_im_gen;
				o_id_ex_to_ALUControl <= o_id_ex_to_ALUControl;
        end
    end

endmodule 