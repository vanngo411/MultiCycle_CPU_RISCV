module hazard_detection_unit(
    input [31:0] ins,
    input [4:0] rd,
    input memrd,
    output control,
    output PCWrite,
    output IFIDWrite
    );
    wire w1, w2, w3, out;
    rs2check r2(ins[6:0], ins[24:20], rd, w2);
    rs1check r1(ins[6:0], ins[19:15], rd, w1);
    assign w3 = w1 | w2;
    assign out = w3 & memrd;
    assign control = out;
    assign PCWrite = ~out;
    assign IFIDWrite = ~out;
endmodule 

module check1(
    input [6:0] op,
    output rs1
    );
    assign rs1 = ((op[6] & (~op[3])) | (~op[2]));
endmodule

module rs1check(
    input [6:0] op,
    input [4:0] rs1,
    input [4:0] rd,
    output o
    );
    wire w1,w2;
    check1 c1(op, w1);			// check for load instruction
    assign w2 = ~(rs1^rd); // rs1 = rd
    assign o = w1 & w2;
endmodule

module check2(
    input [6:0] op,
    output rs2
    );
    assign rs2 = (~op[2])&(op[5])&((~op[6]) | (~op[4]));
endmodule

module rs2check(
    input [6:0] op,
    input [4:0] rs2,
    input [4:0] rd,
    output o
    );
    wire w1,w2;
    check2 c2(op, w1);
    assign w2 = ~(rs2^rd);
    assign o = w1 & w2;
endmodule 