//RISC_V 
module instruction_memory (read_addr, instruction, clk, reset);
	input clk, reset;
	input [31:0] read_addr;
	output [31:0] instruction;
	
	reg [31:0] Memory [63:0];
	integer k;
	
	assign instruction = Memory[read_addr];

	always @(posedge clk)
	begin
		if (reset == 1'b1)
		begin
			for (k=0; k<64; k=k+1) 
			begin// here Ou changes k=0 to k=16
				Memory[k] = 32'h00000000;
			end
		end
		else if (reset == 1'b0)
		begin
			// test for hazard detection
			Memory[4] = 32'b0000000_11001_01010_000_01010_0110011; // add x10, x10, x25	- ALU result: x10=125
			Memory[8] = 32'b00000001010000001011000100000011; //lw x2, 20(x1)  				- ALU result: x2=20
			Memory[12] = 32'b00000000010100010111001000110011; //and x4, x2, x5				- ALU result: x4=28
			
			// test for forwarding module
//			Memory[0] = 32'b0000000_11001_01010_000_01010_0110011; // add x10, x10, x25	
//			Memory[4] = 32'b0000000_11001_01010_000_01010_0110011; // add x10, x10, x25	- ALU result: x10=125
//			Memory[8] = 32'b00000000010101010000010100110011; 			//add x10, x10, x5	- ALU result: x10=133
//			Memory[12] = 32'b00000000101000111000011110110011;		//add x15, x7, x10		- ALU result: x10=200
			
		end
		
		
	end
endmodule
