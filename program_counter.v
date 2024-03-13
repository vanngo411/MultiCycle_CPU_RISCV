// rising-edge synchronous program counter
// output range: decimal 0 to 63 (== I-MEM height)
// data I/O width: 64 = 2^6. Actually, 32 = 2^5; 5+2 offset = 7 bits
// async reset: set program counter to 0 asynchronously
//module program_counter (clk, reset, pc_in, pc_out);
//	input clk, reset;
//	input [6:0] pc_in;
//	output [6:0] pc_out;
//	reg [6:0] pc_out;
//	always @ (posedge clk or posedge reset)
//	
//	begin
//		if(reset==1'b1)
//			pc_out<=0;
//		else
//			pc_out<=pc_in;
//	end
//endmodule



//Code for RISC-V
module program_counter (clk, reset, pc_in, i_PCWrite, i_IFID_PC, pc_out);
	input clk, reset, i_PCWrite;
	input [31:0] pc_in, i_IFID_PC;
	output [31:0] pc_out;
	
	reg [31:0] pc_out;
	always @ (posedge clk or posedge reset )
	
	begin
		if(reset )
			pc_out<=32'h00000000;
		else if (~i_PCWrite)
			pc_out <= i_IFID_PC;
		else
			pc_out<=pc_in;
	end
endmodule
