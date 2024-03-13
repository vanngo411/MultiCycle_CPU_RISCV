module ex_mem_reg(
    input wire i_clk, i_reset,
    // Control signals from ID stage
	 // Control signals for for M block 
	 input wire i_ex_mem_Branch,
	 input wire i_ex_mem_MemRead, 
	 input wire i_ex_mem_MemWrite,
	 // Control signals for for WB block 
	 input wire i_ex_mem_RegWrite,
	 input wire i_ex_mem_MemToReg,  
    // Data from ID stage 		  
	 input wire [31:0] i_ex_mem_Jmp_addr, 
	 input wire [31:0] i_ex_mem_ALU_result,
	 input wire i_ex_mem_zero,
	 input wire [31:0] i_ex_mem_ReadData2,
	 input wire [4:0] i_ex_mem_Rd,
	 
    // Control signals out of EX stage
	 // Control signals for for M block 
	 output reg o_ex_mem_Branch,
	 output reg o_ex_mem_MemRead, 
	 output reg o_ex_mem_MemWrite,
	 // Control signals for for WB block 
	 output reg o_ex_mem_RegWrite,
	 output reg o_ex_mem_MemToReg,  
    // Data from ID stage 		 
	 output reg [31:0] o_ex_mem_Jmp_addr, 
	 output reg [31:0] o_ex_mem_ALU_result,
	 output reg o_ex_mem_zero,
	 output reg [31:0] o_ex_mem_ReadData2,
	 output reg [4:0] o_ex_mem_Rd 
	);

    always @(posedge i_clk or posedge i_reset)
    begin
        if (i_reset)
        begin
				// Control signals for for M block 
				o_ex_mem_Branch <= 0;
				o_ex_mem_MemRead <= 0;
				o_ex_mem_MemWrite <= 0;
				// Control signals for for WB block 
				o_ex_mem_RegWrite <= 0;
				o_ex_mem_MemToReg <= 0;
				// Data from EX stage 		 
				o_ex_mem_Jmp_addr <= 0;
				o_ex_mem_ALU_result <= 0;
				o_ex_mem_zero <= 0;
				o_ex_mem_ReadData2 <= 0;
				o_ex_mem_Rd <= 0;
        end

        else
        begin
				// Control signals for for M block 
				o_ex_mem_Branch <= i_ex_mem_Branch;
				o_ex_mem_MemRead <= i_ex_mem_MemRead;
				o_ex_mem_MemWrite <= i_ex_mem_MemWrite;
				// Control signals for for WB block 
				o_ex_mem_RegWrite <= i_ex_mem_RegWrite;
				o_ex_mem_MemToReg <= i_ex_mem_MemToReg;
				// Data from EX stage 		 
				o_ex_mem_Jmp_addr <= i_ex_mem_Jmp_addr;
				o_ex_mem_ALU_result <= i_ex_mem_ALU_result;
				o_ex_mem_zero <= i_ex_mem_zero;
				o_ex_mem_ReadData2 <= i_ex_mem_ReadData2;
				o_ex_mem_Rd <= i_ex_mem_Rd;
        end
    end

endmodule 