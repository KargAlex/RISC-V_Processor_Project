module calc_enc(input btnc,	// central button 
	input btnl,		// left button
	input btnr,		// right button
	output [3:0] alu_op	// specifies with ALU instruction to execute
);

// alu_op bits are assigned based on given tree
assign alu_op[0] = ( ~btnc & btnr ) | ( btnl & btnr );
assign alu_op[1] = ( !btnl & btnc ) | ( btnc & ~btnr );
assign alu_op[2] = ( btnc & btnr ) | ( ( btnl & ~btnc ) & ~btnr );
assign alu_op[3] = ( ( btnl & ~btnc ) & btnr ) | ( ( btnl & btnc ) & ~btnr );

endmodule