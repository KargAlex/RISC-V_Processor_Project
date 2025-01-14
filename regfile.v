module regfile #(parameter DATAWIDTH = 32)
(
	input clk,				// clock
	input [4:0] readReg1,			// address of read port 1
	input [4:0] readReg2,			// address of read port 2
	input [4:0] writeReg,			// address of write port
	input [DATAWIDTH-1:0] writeData,	// data to write
	input write,				// if = 1, data is written on register[writeReg]
	output [DATAWIDTH-1:0] readData1,	// data to be read port 1
	output [DATAWIDTH-1:0] readData2	// data to be read port 2
);
// Create reg array of 32 DATAWIDTH-bit registers and initialize to 0
reg [DATAWIDTH-1:0] register[0:31];
integer i;
initial begin
	for(i=0;i<DATAWIDTH;i=i+1) begin
		register[i] = 0;
	end
end

// Write data to register if allowed and read data from register
always @(posedge clk) begin

	if(write) begin
		register[writeReg] <= writeData;
	end

end

// If there is a write signal to the same register there is a read signal, write first then read
assign readData1 = (write && (writeReg == readReg1)) ? writeData : register[readReg1]; 
assign readData2 = (write && (writeReg == readReg2)) ? writeData : register[readReg2];

endmodule
