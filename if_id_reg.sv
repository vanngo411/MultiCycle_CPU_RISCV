module if_id_reg(
    input  wire i_clk, i_reset, i_IFIDWrite,
//	 input  wire i_we, i_flush,
//    input  wire [31:0] i_if_p4, 
	 input  wire [31:0] i_if_pc, i_if_instr,
    output reg  [31:0] o_id_pc, 
    output reg [31:0] o_id_instr
);

    reg [31:0] id_instr;

    always @(posedge i_clk or posedge i_reset )
    begin
        if(i_reset )
        begin
//            o_id_p4    <= 'b0;
            o_id_pc    <= 'b0;
            o_id_instr <= 'b0;
        end

        else if (~i_IFIDWrite)
        begin
//            o_id_p4    <= 'b0;
            o_id_pc    <= i_if_pc; 
            o_id_instr <= 32'h00007013; // andi x0, x0, 0
        end

        else
        begin
            // Not sure we using, don't wire out <if(i_we)>
//                o_id_p4    <= i_if_p4;
                o_id_pc    <= i_if_pc;
                o_id_instr <= i_if_instr;
           
        end
    end

    // assign o_id_instr = (i_flush) ? 32'h00007013 : id_instr; // if flush -> andi x0, x0, 0 | else -> id instr gets if instr

endmodule 