module Mux_ForwardA(Sel , A1, B1, C1, Mux_ForwardA_out);
	input [1:0] Sel;
	input [31:0] A1, B1, C1;
	output [31:0] Mux_ForwardA_out;
	
	assign Mux_ForwardA_out = Sel[1] ? (Sel[0] ? A1 : C1) : (Sel[0] ? B1 : A1);
endmodule 