module top_proc_tb;

    
    reg clk;
    reg rst;

    // Inputs and outputs related to top_proc
    wire [31:0] PC;
    wire [31:0] dAddress;
    wire [31:0] dWriteData;
    wire [31:0] WriteBackData;
    wire MemRead;
    wire MemWrite;
    wire [31:0] instr;		// From ROM
    wire [31:0] dReadData;  	// From RAM

    // Instantiation of ROM and RAM
    INSTRUCTION_MEMORY rom (
        .clk(clk),
        .addr(PC[8:0]),   // Instruction address (word-aligned)
        .dout(instr)       // Fetched instruction
    );

    DATA_MEMORY ram (
        .clk(clk),
        .we(MemWrite),
        .addr(dAddress[8:0]), // Data address (word-aligned)
        .din(dWriteData),
        .dout(dReadData)
    );

    // Instantiate top_proc
    top_proc #(
        .INITIAL_PC(32'h00400000)  // Initial program counter
    ) uut (
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .dReadData(dReadData),
        .PC(PC),
        .dAddress(dAddress),
        .dWriteData(dWriteData),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .WriteBackData(WriteBackData)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize reset
        rst = 1;
        #6;
        rst = 0;

        // Wait for simulation to complete
        #10000;  // Run the simulation for a sufficient amount of time
        $finish;
    end

 
  
endmodule

