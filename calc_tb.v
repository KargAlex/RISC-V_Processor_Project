module calc_tb;

	reg clk, btnc, btnl, btnu, btnr, btnd;	
	reg [15:0] sw;
	wire [15:0] led;

// Instantiate the calculator module
calc uut (
        .clk(clk),
        .btnc(btnc),
        .btnl(btnl),
        .btnu(btnu),
        .btnr(btnr),
        .btnd(btnd),
        .sw(sw),
        .led(led)
);

// Clock generation: Toggle every 5 time units
always #5 clk = ~clk;

// Test sequence
initial begin
        // Initialize inputs
        clk = 0;
        btnc = 0;
        btnl = 0;
        btnu = 0;
        btnr = 0;
        btnd = 0;
        sw = 16'b0;

        // Display header for test results
        $display("Time\t btnl btnc btnr btnd btnu sw (hex)\t LED (hex)");
        $monitor("%0t\t %b   %b   %b   %b   %b   %h\t %h", $time, btnl, btnc, btnr, btnd, btnu, sw, led);

        // Test 1: Reset accumulator
        btnu = 1; // Press reset button (btnu)
        #10 btnu = 0; // Release reset button
        #10;

	// Test 2: ADD operation
        btnl = 0;        
        btnc = 1;        
        btnr = 0;
        sw = 16'h354a;   
        btnd = 1;       // Press btnd (apply operation)
        #10 btnd = 0;    
        #20;

        // Test 3: SUBTRACT operation
        btnl = 0;
        btnc = 1;        
        btnr = 1;
        sw = 16'h1234;   
        btnd = 1;       // Press btnd (apply operation)
        #10 btnd = 0;
        #20;

	// Test 4: OR operation
        btnl = 0;        
        btnc = 0;        
        btnr = 1;
        sw = 16'h1001;
        btnd = 1;	// Press btnd (apply operation)
        #10 btnd = 0;
        #20;

        // Test 5: AND operation
        btnl = 0;	
        btnc = 0;
        btnr = 0;
	sw = 16'hf0f0;
        btnd = 1;	// Press btnd (apply operation)
        #10 btnd = 0;
        #20;

	// Test 6: XOR operation
        btnl = 1;
        btnc = 1;
        btnr = 1;        
        sw = 16'h1fa2;   
        btnd = 1;	// Press btnd (apply operation)
        #10 btnd = 0; 
        #20;

	// Test 7: ADD operation
        btnl = 0;        
        btnc = 1;        
        btnr = 0;
        sw = 16'h6aa2;   
        btnd = 1;        // Press btnd (apply operation)
        #10 btnd = 0;
        #20;

	// Test 8: Logical Shift Left
        btnl = 1;
        btnc = 0;
        btnr = 1;
        sw = 16'h0004;
        btnd = 1;        // Press btnd (apply operation)
        #10 btnd = 0;
        #20;

	// Test 9: Arithmetic Shift Right
        btnl = 1;
        btnc = 1;
        btnr = 0;
        sw = 16'h0001;
        btnd = 1;	// Press btnd (apply operation)
        #10 btnd = 0;
        #20;

        // Test 10: SLT operation (Set Less Than)
        btnl = 1;
        btnc = 0;
        btnr = 0;
        sw = 16'h46ff;
        btnd = 1;        // Press btnd (apply operation)
        #10 btnd = 0;
        #20;

        // End the simulation
        $stop;
    end

endmodule	
