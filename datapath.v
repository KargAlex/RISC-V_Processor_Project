module datapath #(parameter INITIAL_PC = 32'h400000)
( 	input clk,
	input rst,		// synchronous reset
	input [31:0] instr,	// instruction data from instuction memory
	input PCSrc,		// PC source
	input ALUSrc,		// source of 2nd ALU operand
	input RegWrite,		// writes data to Registers
	input MemToReg,		// input mux to registers
	input [3:0] ALUCtrl,	// ALU control signal
	input loadPC,		// updates PC
	output [31:0] PC,	// Program Counter
	output Zero,		// 1 if (ALU zero == 1)
	output [31:0] dAddress, 	// address of data memory
	output [31:0] dWriteData,	// data to write in data memory
	input [31:0] dReadData,		// data to read from data memory
	output [31:0] WriteBackData	// WriteBack data which return to registers
);
//Internal signals
reg [31:0] imm_out;
wire [31:0] alu_op1;
wire [31:0] alu_op2;
wire [31:0] alu_result;
wire [31:0] branch_target;

// PC Logic
reg [31:0] tempPC;
always @(posedge clk) begin
	$display("ALUSrc: %d and immediate: %d", ALUSrc, imm_out);
	if (rst) begin
		tempPC <= INITIAL_PC;		// reset
		$display("TempPc: %d and PC value: %d", tempPC, PC);
	end else if (loadPC) begin
		if (PCSrc) begin
			tempPC <= branch_target ;	// branch
		end else begin
			tempPC <= PC + 4;		// next instruction
		end
		$display("Updating PC. Instr: %d", instr);
	end
end
assign PC = tempPC;

// Register variables
wire [31:0] readData1, readData2;
//Regfile instantiation
regfile datapath_regfile (
	.clk(clk),
        .readReg1(instr[19:15]),  	// rs1
        .readReg2(instr[24:20]),  	// rs2
        .writeReg(instr[11:7]),		// rd
        .writeData(WriteBackData), 	// Data to write back
        .write(RegWrite),          	// Write enable signal
        .readData1(readData1),    	// Output for register 1 data
        .readData2(readData2)      	// Output for register 2 data
);

//Immediate Generation 
always @(*) begin
        case (instr[6:0])
            7'b0010011: imm_out = {{20{instr[31]}}, instr[31:20]};  // I-type
            7'b0100011: imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]};  // S-type
            7'b1100011: imm_out = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // B-type
        endcase
    end

// ALU operands
assign alu_op1 = readData1;
assign alu_op2 = (ALUSrc) ? imm_out : readData2;	// If (ALUSrc): 2nd operand = imm_out 
						  	//else: 2nd operand = ReadData2
// ALU instantation
alu datapath_alu (
	.op1(alu_op1),       	// First ALU operand (from register file)
	.op2(alu_op2),         	// Second ALU operand (from immediate or register)
	.alu_op(ALUCtrl),      	// ALU control signal
	.result(alu_result),   	// ALU result
	.zero(Zero)       	// Zero flag 
);


// Branch target
assign branch_target = PC + {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};

// combinational logic preperation for dAddress and WriteBackData
reg [31:0] alu_result_wb; 
always @(posedge clk or posedge rst) begin
        if (rst) begin
            alu_result_wb <= 32'b0;  // Reset
        end else begin
            alu_result_wb <= alu_result; 
        end
    end

//Write Back
assign WriteBackData = (MemToReg) ? dReadData : alu_result_wb;  	// Select between ALU result or data from memory


//Memory Addressing
assign dAddress = alu_result_wb;  	// ALU result gives memory address
assign dWriteData = readData2; 	// Data to be written to memory

endmodule