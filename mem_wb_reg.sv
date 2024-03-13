module mem_wb_reg(
    input wire i_clk, i_reset,
    // Control signals from MEM stage
	 // Control signals for for WB block 
	 input wire i_mem_wb_RegWrite,
	 input wire i_mem_wb_MemToReg,  
    // Data from ID stage 		  
	 input wire [31:0] i_mem_wb_Read_Data,
	 input wire [31:0] i_mem_wb_ALU_result,
	 input wire [4:0] i_mem_wb_Rd,
	 
    // Control signals out of MEM stage
	 // Control signals for for WB block 
	 output reg o_mem_wb_RegWrite,
	 output reg o_mem_wb_MemToReg,  
    // Data from ID stage 
	 output reg [31:0] o_mem_wb_Read_Data,
	 output reg [31:0] o_mem_wb_ALU_result,
	 output reg [4:0] o_mem_wb_Rd
	);

    always @(posedge i_clk or posedge i_reset)
    begin
        if (i_reset)
        begin
				// Control signals for for WB block 
				o_mem_wb_RegWrite <= 0;
				o_mem_wb_MemToReg <= 0;
				// Data from EX stage 		 
				o_mem_wb_Read_Data <= 0;
				o_mem_wb_ALU_result <= 0;
				o_mem_wb_Rd <= 0;
        end

        else
        begin
				// Control signals for for WB block 
				o_mem_wb_RegWrite <= i_mem_wb_RegWrite;
				o_mem_wb_MemToReg <= i_mem_wb_MemToReg;
				// Data from EX stage 		 
				o_mem_wb_Read_Data <= i_mem_wb_Read_Data;
				o_mem_wb_ALU_result <= i_mem_wb_ALU_result;
				o_mem_wb_Rd <= i_mem_wb_Rd;
        end
    end

endmodule