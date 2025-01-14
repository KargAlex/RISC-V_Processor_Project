module alu(	
	input [31:0] op1, 		// operand 1, two's complement
	input [31:0] op2, 		// operand 2, two's complement
	input [3:0] alu_op, 		// shows which instruction to execute
	output zero,			// = 1 when result is 0
	output reg [31:0] result );

parameter [3:0] ALUOP_AND = 4'b0000;
parameter [3:0] ALUOP_OR  = 4'b0001;
parameter [3:0] ALUOP_ADD = 4'b0010;
parameter [3:0] ALUOP_SUB = 4'b0110;
parameter [3:0] ALUOP_SLT = 4'b0100;
parameter [3:0] ALUOP_SRL = 4'b1000;
parameter [3:0] ALUOP_SLL = 4'b1001;
parameter [3:0] ALUOP_SRA = 4'b1010;
parameter [3:0] ALUOP_XOR = 4'b0101;


always @ (*) 	// (*) includes all signals used inside the always block 
	begin
		case(alu_op)
			ALUOP_AND: result = op1 & op2;					// Bitwise AND
			ALUOP_OR: result = op1 | op2;					// Bitwise OR
			ALUOP_ADD: result = op1 + op2;
			ALUOP_SUB: result = op1 - op2;
			ALUOP_SLT: result = ($signed(op1) < $signed(op2)); 		// result = 1 if ((signed)op1 < (signed)op2), else result = 0
			ALUOP_SRL: result = op1 >> op2[4:0]; 				// Logical Shift Right
			ALUOP_SLL: result = op1 << op2[4:0]; 				// Logical Shift Left
			ALUOP_SRA: result = $unsigned($signed(op1) >>> op2[4:0]); 	// Arithmetic Shift Right
			ALUOP_XOR: result = op1 ^ op2;					// Logical XOR (Bitwise)
		endcase

	end
assign zero = (result == 32'b0) ? 1'b1 : 1'b0; // zero = 1 if result = 0

endmodule