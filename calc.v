module calc(input clk,		// clock
	input btnc,		// central button 
	input btnl,		// left button
	input btnu,		// up button, resets accumulator
	input btnr,		// right button
	input btnd,		// down button
	input [15:0] sw,	// switches for data input
	output reg [15:0] led 	// LED for accumulator output
);

	// Internal signals
	reg [15:0] accumulator;		// stores 16 bits of ALU result
	wire [31:0] op1_extended;     	// Sign-extended accumulator to 32-bit
    	wire [31:0] op2_extended;     	// Sign-extended switch input to 32-bit
    	wire [31:0] result;           	// ALU result
    	wire zero;                    	// Zero flag from ALU
    	wire [3:0] alu_op;             	// ALU operation
	
assign op1_extended = {{16{accumulator[15]}}, accumulator};	// Sign extension of accumulator to 32 bits
assign op2_extended = {{16{sw[15]}}, sw};  			// Sign extension of switch input to 32 bits

// Calc_enc instance
calc_enc my_calc_enc (
	.btnc(btnc),
        .btnl(btnl),
        .btnr(btnr),
        .alu_op(alu_op)
);

// ALU instance
alu my_alu (
	.op1(op1_extended),
        .op2(op2_extended),
        .alu_op(alu_op),
        .result(result),
        .zero(zero)
);

// Accumulator logic
always @(posedge clk) begin
	if(btnu) begin
		accumulator <= 16'b0;	// Reset when btnu is presed
	end
	else if(btnd) begin
		accumulator <= result[15:0];	// Take lower 16 bits of ALU result
	end

	led <= accumulator; // outputs accumulator value to led
	
end

endmodule