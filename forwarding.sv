module forwarding 
	(
	input wire i_clk, i_reset,
	input wire [4:0] i_id_ex_Rs1,
	input wire [4:0] i_id_ex_Rs2,
	input wire [4:0] i_mem_wb_Rd,
	input wire [4:0] i_ex_mem_Rd,
	input wire i_mem_wb_RegWrite,
	input wire i_ex_mem_RegWrite,
	
	output reg [1:0] o_forwardA,
	output reg [1:0] o_forwardB
	);
	
	always @(i_ex_mem_RegWrite or i_mem_wb_RegWrite)
	begin
		if (i_reset)
		begin
			o_forwardA = 2'b00;
			o_forwardB = 2'b00;
		end
		else 
		begin
			// EX hazard
			if (i_ex_mem_RegWrite)
			begin
				if (i_ex_mem_Rd != 0)
				begin
					if (i_ex_mem_Rd == i_id_ex_Rs1)
					begin
						o_forwardA = 2'b10;
						o_forwardB = 2'b00;
					end
					else if (i_ex_mem_Rd == i_id_ex_Rs2)
					begin
						o_forwardA = 2'b00;
						o_forwardB = 2'b10;
					end
				end
			end
			else if (i_mem_wb_RegWrite)
			begin
				if (i_mem_wb_Rd != 0)
				begin
					if (i_mem_wb_Rd == i_id_ex_Rs1)
					begin
						o_forwardA = 2'b01;
						o_forwardB = 2'b00;
					end
					else if (i_mem_wb_Rd == i_id_ex_Rs2)
					begin
						o_forwardA = 2'b00;
						o_forwardB = 2'b01;
					end
				end
			end
			else 
			begin
				o_forwardA = 2'b00;
				o_forwardB = 2'b00;
			end
		end
	end
endmodule 