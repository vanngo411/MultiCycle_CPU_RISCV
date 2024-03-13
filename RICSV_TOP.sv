module RICSV_TOP(
	input clk, reset
	);

	wire [31:0] instruction_outTop, read_data1Top, read_data2Top, ALUresultTop, toALU, Data_outTop, writeBackTop, im_genTop, jmp_addrTop;
	wire [3:0] ALUControl_outTop; ///??????????????
	wire RegWriteTop, MemWriteTop, MemReadTop, ALUSrcTop, MemtoRegTop, ZeroTop, AndGate_outTop, branch_outTop;
	wire [1:0] ALUOpTop;
	wire [31:0] PCtop, NextToPCtop, Mux3_outTop;
	
	
//	wire [7:0] led_outTop;
	wire [7:0] data_to_LED_Top;
	wire [2:0] read_address_LED;
	reg [2:0] read_address_for_LED;
	wire [2:0] counter_outTop, counter_out_slowerTop;
	integer count;
	logic clkx4;
	
	//wire for IF/ID register
	wire [31:0] o_if_id_pcTop, o_if_id_instructionTop;
	//wire for ID/EX register
	wire [31:0] o_id_ex_pcTop;
	wire [1:0] o_id_ex_ALUOpTop;
	wire o_id_ex_ALUSrcTop, o_id_ex_BranchTop, o_id_ex_MemReadTop, o_id_ex_MemWriteTop, o_id_ex_RegWriteTop, o_id_ex_MemToRegTop;
	wire [31:0] o_id_ex_im_genTop, o_id_ex_Read_data1Top, o_id_ex_Read_data2Top; 
	wire [4:0] o_id_ex_Rs1Top, o_id_ex_RdTop, o_id_ex_Rs2Top; 
	wire [31:0] o_id_ex_to_ALUControlTop; //still full instruction, cut off when connect to ALUControl
	//wire for EX/MEM
	wire o_ex_mem_BranchTop, o_ex_mem_MemReadTop, o_ex_mem_MemWriteTop, o_ex_mem_RegWriteTop, o_ex_mem_MemToRegTop, o_ex_mem_ReadData2Top;
	wire [31:0] o_ex_mem_Jmp_addrTop,o_ex_mem_ALU_resultTop; 
	wire o_ex_mem_zeroTop;
	wire [4:0] o_ex_mem_RdTop;
	//wire for MEM/WB
	wire o_mem_wb_RegWriteTop, o_mem_wb_MemToRegTop;
	wire [31:0] o_mem_wb_Read_DataTop, o_mem_wb_ALU_resultTop;
	wire [4:0] o_mem_wb_RdTop;
	//wire for forwarding
	wire [1:0] o_forwardATop;
	wire [1:0] o_forwardBTop;
	//wire for Mux forwarding
	wire [31:0] o_Mux_ForwardA_outTop;
	wire [31:0] o_Mux_ForwardB_outTop;
	// wire for hazard detection
	wire o_hazard_detection_controlTop, o_hazard_detection_PCWriteTop, o_hazard_detection_IFIDWriteTop;
	wire [1:0] o_Mux4_ALUOpTop;
	wire o_Mux4_ALUSrcTop, o_Mux4_branch_outTop, o_Mux4_MemReadTop, o_Mux4_MemWriteTop, o_Mux4_RegWriteTop, o_Mux4_MemtoRegTop;
	
	// New adding for lab2
	// Register IF/ID
	if_id_reg if_id_reg
	(
    .i_clk(clk),
	 .i_reset(reset), 
	 .i_IFIDWrite(o_hazard_detection_IFIDWriteTop),
//	 .i_we(), 
//	 .i_flush(),
//    .i_if_p4(), 
	 .i_if_pc(PCtop), 
	 .i_if_instr(instruction_outTop),
//    .o_id_p4(), 
	 .o_id_pc(o_if_id_pcTop), 
    .o_id_instr(o_if_id_instructionTop)
	 );
	 
	// Register ID/EX
	id_exe_reg id_exe_reg
	(
    .i_clk(clk), 
	 .i_reset(reset),
    // Control signals from ID stage
	 // Control signals for for EX block
	 .i_id_ex_ALUOp(o_Mux4_ALUOpTop), 
	 .i_id_ex_ALUSrc(o_Mux4_ALUSrcTop), 
	 // Control signals for for M block 
	 .i_id_ex_Branch(o_Mux4_branch_outTop),
	 .i_id_ex_MemRead(o_Mux4_MemReadTop), 
	 .i_id_ex_MemWrite(o_Mux4_MemWriteTop),
	 // Control signals for for WB block 
	 .i_id_ex_RegWrite(o_Mux4_RegWriteTop),
	 .i_id_ex_MemToReg(o_Mux4_MemtoRegTop),  
    // Data from ID stage 
	 .i_id_ex_PC(o_if_id_pcTop),
	 .i_id_ex_Read_data1(read_data1Top), 
	 .i_id_ex_Read_data2(read_data2Top),
	 .i_id_ex_Rs1(o_if_id_instructionTop[19:15]),
	 .i_id_ex_Rs2(o_if_id_instructionTop[24:20]),
    .i_id_ex_Rd(o_if_id_instructionTop[11:7]),
	 .i_id_ex_im_gen(im_genTop), 
	 .i_id_ex_to_ALUControl(o_if_id_instructionTop),
    // Control signals out of EX stage
	 // Control signals for for EX block
	 .o_id_ex_ALUOp(o_id_ex_ALUOpTop), 
	 .o_id_ex_ALUSrc(o_id_ex_ALUSrcTop), 
	 // Control signals for for M block 
	 .o_id_ex_Branch(o_id_ex_BranchTop),
	 .o_id_ex_MemRead(o_id_ex_MemReadTop), 
	 .o_id_ex_MemWrite(o_id_ex_MemWriteTop),
	 // Control signals for for WB block 
	 .o_id_ex_RegWrite(o_id_ex_RegWriteTop),
	 .o_id_ex_MemToReg(o_id_ex_MemToRegTop),  
    // Data from ID stage
	 .o_id_ex_PC(o_id_ex_pcTop),
	 .o_id_ex_Read_data1(o_id_ex_Read_data1Top), 
	 .o_id_ex_Read_data2(o_id_ex_Read_data2Top),
	 .o_id_ex_Rs1(o_id_ex_Rs1Top), // wait for forward
	 .o_id_ex_Rs2(o_id_ex_Rs2Top), // wait for forward
    .o_id_ex_Rd(o_id_ex_RdTop),
	 .o_id_ex_im_gen(o_id_ex_im_genTop),
	 .o_id_ex_to_ALUControl(o_id_ex_to_ALUControlTop) //still full instruction
	);
	
	ex_mem_reg ex_mem_reg
	(
    .i_clk(clk), 
	 .i_reset(reset),
    // Control signals from ID stage
	 // Control signals for for M block 
	 .i_ex_mem_Branch(o_id_ex_BranchTop),
	 .i_ex_mem_MemRead(o_id_ex_MemReadTop), 
	 .i_ex_mem_MemWrite(o_id_ex_MemWriteTop),
	 // Control signals for for WB block 
	 .i_ex_mem_RegWrite(o_id_ex_RegWriteTop),
	 .i_ex_mem_MemToReg(o_id_ex_MemToRegTop),  
    // Data from ID stage 		  
	 .i_ex_mem_Jmp_addr(jmp_addrTop), 
	 .i_ex_mem_ALU_result(ALUresultTop),
	 .i_ex_mem_zero(ZeroTop),
	 .i_ex_mem_ReadData2(o_forwardBTop),
	 .i_ex_mem_Rd(o_id_ex_RdTop),
	 
    // Control signals out of EX stage
	 // Control signals for for M block 
	 .o_ex_mem_Branch(o_ex_mem_BranchTop),
	 .o_ex_mem_MemRead(o_ex_mem_MemReadTop), 
	 .o_ex_mem_MemWrite(o_ex_mem_MemWriteTop),
	 // Control signals for for WB block 
	 .o_ex_mem_RegWrite(o_ex_mem_RegWriteTop),
	 .o_ex_mem_MemToReg(o_ex_mem_MemToRegTop),  
    // Data from ID stage 		 
	 .o_ex_mem_Jmp_addr(o_ex_mem_Jmp_addrTop), 
	 .o_ex_mem_ALU_result(o_ex_mem_ALU_resultTop),
	 .o_ex_mem_zero(o_ex_mem_zeroTop),
	 .o_ex_mem_ReadData2(o_ex_mem_ReadData2Top),
	 .o_ex_mem_Rd(o_ex_mem_RdTop) 
	);
	
	mem_wb_reg mem_wb_reg
	(
    .i_clk(clk), 
	 .i_reset(reset),
    // Control signals from MEM stage
	 // Control signals for for WB block 
	 .i_mem_wb_RegWrite(o_ex_mem_RegWriteTop),
	 .i_mem_wb_MemToReg(o_ex_mem_MemToRegTop),  
    // Data from ID stage 		  
	 .i_mem_wb_Read_Data(Data_outTop),
	 .i_mem_wb_ALU_result(o_ex_mem_ALU_resultTop),
	 .i_mem_wb_Rd(o_ex_mem_RdTop),
	 
    // Control signals out of MEM stage
	 // Control signals for for WB block 
	 .o_mem_wb_RegWrite(o_mem_wb_RegWriteTop),
	 .o_mem_wb_MemToReg(o_mem_wb_MemToRegTop),  
    // Data from ID stage 
	 .o_mem_wb_Read_Data(o_mem_wb_Read_DataTop),
	 .o_mem_wb_ALU_result(o_mem_wb_ALU_resultTop),
	 .o_mem_wb_Rd(o_mem_wb_RdTop)
	);
	
	
	
	forwarding forwarding 
	(
	.i_clk(clk), 
	.i_reset(reset),
	.i_id_ex_Rs1(o_id_ex_Rs1Top),
	.i_id_ex_Rs2(o_id_ex_Rs2Top),
	.i_mem_wb_Rd(o_mem_wb_RdTop),
	.i_ex_mem_Rd(o_ex_mem_RdTop),
	.i_mem_wb_RegWrite(o_mem_wb_RegWriteTop),
	.i_ex_mem_RegWrite(o_ex_mem_RegWriteTop),
	.o_forwardA(o_forwardATop),
	.o_forwardB(o_forwardBTop)
	);
	
	
	
	Mux_ForwardA Mux_ForwardA
	(
	.Sel(o_forwardATop),
	.A1(o_id_ex_Read_data1Top), 
	.B1(writeBackTop),
	.C1(o_ex_mem_ALU_resultTop),
	.Mux_ForwardA_out(o_Mux_ForwardA_outTop)
	);
	
	Mux_ForwardB Mux_ForwardB
	(
	.Sel(o_forwardBTop),
	.A1(o_id_ex_Read_data2Top), 
	.B1(writeBackTop),
	.C1(o_ex_mem_ALU_resultTop),
	.Mux_ForwardB_out(o_Mux_ForwardB_outTop)
	);
	
	
	
	// hazard detection
	hazard_detection_unit hazard_detection_unit(
    .ins(o_if_id_instructionTop),
    .rd(o_id_ex_RdTop),
    .memrd(o_id_ex_MemReadTop),
    .control(o_hazard_detection_controlTop),
    .PCWrite(o_hazard_detection_PCWriteTop),
    .IFIDWrite(o_hazard_detection_IFIDWriteTop)
    );
	 
	
	
	//Mux 4 from control to ID/EX register
	Mux4_ForControl Mux4_ForControl
	(
	.Sel(o_hazard_detection_controlTop),
	.i_Mux4_ALUOp(ALUOpTop), 
	.i_Mux4_ALUSrc(ALUSrcTop), 
	.i_Mux4_branch_out(branch_outTop),
	.i_Mux4_MemRead(MemReadTop), 
	.i_Mux4_MemWrite(MemWriteTop),
	.i_Mux4_RegWrite(RegWriteTop),
	.i_Mux4_MemtoReg(MemtoRegTop), 
	.o_Mux4_ALUOp(o_Mux4_ALUOpTop), 
	.o_Mux4_ALUSrc(o_Mux4_ALUSrcTop), 
	.o_Mux4_branch_out(o_Mux4_branch_outTop),
	.o_Mux4_MemRead(o_Mux4_MemReadTop), 
	.o_Mux4_MemWrite(o_Mux4_MemWriteTop),
	.o_Mux4_RegWrite(o_Mux4_RegWriteTop),
	.o_Mux4_MemtoReg(o_Mux4_MemtoRegTop)
	);	
	
	
	// PC +4
	PCplus4 PCplus4 
	(
	.fromPC(PCtop), 
	.nextToPC(NextToPCtop)
	);
	
	//PC
	program_counter program_counter 
	(.clk(clk), 
	.reset(reset), 
	.pc_in(Mux3_outTop), 
	.i_PCWrite(o_hazard_detection_PCWriteTop),
	.i_IFID_PC(o_if_id_pcTop),
	.pc_out(PCtop)
	);
	
	//Memory of instruction
	instruction_memory instruction_memory 
	(
	.read_addr(PCtop), 
	.instruction(instruction_outTop),
	.clk(clk),
	.reset(reset));
	
	// Register File
	register_file register_file 
	(
	.clk(clk), 
	.reset(reset), 
	.Rs1(o_if_id_instructionTop[19:15]), 
	.Rs2(o_if_id_instructionTop[24:20]), 
	.Rd(o_mem_wb_RdTop),      // Next to fix, not take value from instrctrion, should be from MEM/WR registor
	.Write_data(writeBackTop), // skipped MUX
	.RegWrite(o_mem_wb_RegWriteTop), 
	.Read_data1(read_data1Top), 
	.Read_data2(read_data2Top) // review again
	);
	
	//ALU
	alu alu
	(
	.A(o_Mux_ForwardA_outTop), 
	.B(toALU), 
	.zero(ZeroTop), 
	.ALUControl_in(ALUControl_outTop), 
	.ALU_result(ALUresultTop)
	);
	
	//Mux1
	Mux1 Mux1
	(
	.Sel(o_id_ex_ALUSrcTop) , 
	.A1(o_Mux_ForwardB_outTop),  // verify
	.B1(o_id_ex_im_genTop), 
	.Mux1_out(toALU)
	);
	
	// ALU control
	ALUControl ALUControl 
	(
	.ALUOp_in(o_id_ex_ALUOpTop), 
	.func7(o_id_ex_to_ALUControlTop[31:25]), //cut off from full instruction, not fix to much on base code
	.func3(o_id_ex_to_ALUControlTop[14:12]), //cut off from full instruction, not fix to much on base code
	.ALUControl_out(ALUControl_outTop) //ALUControl_outTop is needed verify 32 or 4 bits
	);
	
	
	data_memory data_memory
	(
	.clk(clk), 
	.reset(reset), 
	.MemWrite(o_ex_mem_MemWriteTop), 
	.MemRead(o_ex_mem_MemReadTop), 
	.Address(o_ex_mem_ALU_resultTop), 
	.write_data(o_ex_mem_ReadData2Top), 
	.Read_Data(Data_outTop)
	);
	
	Mux2 Mux2
	(
	.Sel(o_mem_wb_MemToRegTop), 
	.A2(o_mem_wb_ALU_resultTop), 
	.B2(o_mem_wb_Read_DataTop), 
	.Mux2_out(writeBackTop)
	);
	

	control control 
	(
	.reset(reset),
	.OPcode(o_if_id_instructionTop[6:0]), 
	.branch(branch_outTop), 
	.MemRead(MemReadTop), 
	.MemtoReg(MemtoRegTop), 
	.MemWrite(MemWriteTop), 
	.ALUSrc(ALUSrcTop), 
	.RegWrite(RegWriteTop), 
	.ALUOp_out(ALUOpTop)
	);
	
	// Immediate Generator 32 - 32
	immediate_Generator immediate_Generator
	(
	.reset(reset),
	.instruction(o_if_id_instructionTop),
	.im_gen(im_genTop)
	);
	
	// Jump adder
	jmp_adder jmp_adder
	(
    .reset(reset),
    .read_addr(o_id_ex_pcTop),
    .im_gen(o_id_ex_im_genTop),
    .jmp_addr(jmp_addrTop)
	);
	
	Mux3 Mux3
	(
	.Sel(AndGate_outTop), 
	.A3(NextToPCtop), 
	.B3(o_ex_mem_Jmp_addrTop), 
	.Mux3_out(Mux3_outTop)
	);
	
	AndGate AndGate
	(
	.zero(o_ex_mem_zeroTop), 
	.branch(o_ex_mem_BranchTop),
	.pc_sel(AndGate_outTop)
	);	
	
	// LED showing RAM
	RAM_for_LEDShowing RAM_for_LEDShowing
	(
	.clk(clk), 
	.reset(reset), 
	.write_signal(o_mem_wb_RegWriteTop), 
	.read_address(counter_out_slowerTop), 
	.write_address(counter_outTop), 
	.write_data(writeBackTop), 
	.Read_Data(data_to_LED_Top)
	);
	
	Clock_divider Clock_divider
	(
	.clock_in(clk),
	.clock_out(clkx4)
    );
	
	up_counter up_counter
	(
	.clk(clk), 
	.reset(reset), 
	.counter(counter_outTop)
    );
	 
	 up_counter up_counter_slower
	(
	.clk(clkx4), 
	.reset(reset), 
	.counter(counter_out_slowerTop)
    );

endmodule 





//======================

module RICSV_TOP_tb;
	reg clk, reset;
	
	RICSV_TOP dut 
	(
	.clk(clk),
	.reset(reset)
	);
	
	// clock generation
	initial 
	begin
		clk = 0;
	end
	always #50 clk =~clk;
	
	initial
	begin
		reset = 1'b1;
		#50;
		reset = 1'b0;
		#50;
	end
	
endmodule 