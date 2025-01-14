module top_proc #(
    parameter INITIAL_PC = 32'h00400000
)(
    	input clk,                   // Clock
    	input rst,                   // Reset
    	input [31:0] instr,          // Instruction fetched from instruction memory
    	input [31:0] dReadData,      // Data read from data memory
    	output [31:0] PC,            // Program Counter
    	output [31:0] dAddress,      // Data memory address
    	output [31:0] dWriteData,    // Data to write to memory
    	output reg MemRead,          // Memory read enable
    	output reg MemWrite,         // Memory write enable
    	output [31:0] WriteBackData  // Data written back to registers
);

    // FSM States
    localparam [2:0] IF  = 3'b000,
                     ID  = 3'b001,
                     EX  = 3'b010,
                     MEM = 3'b011,
                     WB  = 3'b100;

    // Current state and next state registers
    reg [2:0] state;

    // Internal signals
    reg loadPC, PCSrc, ALUSrc, RegWrite, MemToReg;
    wire Zero;
    reg [3:0] ALUCtrl;
    wire [31:0] alu_result;

    // Datapath Instantiation
    datapath dp (
        .clk(clk),                   
        .rst(rst),                   
        .instr(instr),               // Instruction fetched from instruction memory
        .PCSrc(PCSrc),               // Branch decision signal
        .ALUSrc(ALUSrc),             // Selects between register and immediate for ALU
        .RegWrite(RegWrite),         // Enables writing to the register file
        .MemToReg(MemToReg),         // Selects data memory output for write-back
        .ALUCtrl(ALUCtrl),           // ALU operation control signal
        .loadPC(loadPC),             // Updates the PC
        .PC(PC),                     // Program Counter output
        .Zero(Zero),                 // ALU Zero flag
        .dAddress(dAddress),         // Address for accessing data memory
        .dWriteData(dWriteData),     // Data to be written to memory
        .dReadData(dReadData),       // Data read from memory
        .WriteBackData(WriteBackData) // Data written back to registers
    );

// FSM Logic
always @(posedge clk) begin
        if (rst) begin
            state <= IF;
        end else begin
        case (state)
		IF: begin
			state <= ID;
		end
		ID: begin
			state <= EX; 
		end
		EX: begin
			state <= MEM; 
		end
		MEM: begin
			state <= WB; 
		end
		WB: begin
			state <= IF; 
		end
		default: state <= IF;
	endcase
    end
end

    always @(*) begin
        // Default values
        loadPC = 0; PCSrc = 0; RegWrite = 0;
        MemToReg = 0; MemRead = 0; MemWrite = 0;
	
	$display("Entering state.   State: %d, instr, PC: %d : %d", state, instr, PC);
        case (state)
            IF: begin
		PCSrc = 0; // PCSrc can be 1 only when current instruction is BEQ AND Zero == 1
		loadPC = 0;
		RegWrite = 0;
		MemToReg = 0;
            end
            ID: begin
                // Decode instruction
		case (instr[6:0])
			7'b0110011: begin // R-Type
                        	case (instr[14:12])
                            		3'b000: ALUCtrl = (instr[30] ? 4'b0110 : 4'b0010); // SUB or ADD
				        3'b001: ALUCtrl = 4'b1001; // SLL 
					3'b010: ALUCtrl = 4'b1001; // SLT
					3'b100: ALUCtrl = 4'b0101; // XOR
					3'b101: ALUCtrl = (instr[30] ? 4'b1010 : 4'b1000); // SRA or SRL
   					3'b110: ALUCtrl = 4'b0001; // OR                			
					3'b111: ALUCtrl = 4'b0000; // AND	
                        	endcase
                    	end
                    	7'b0010011: begin // I-Type
                        	ALUSrc = 1; // Use immediate
                        	case (instr[14:12])
                            		3'b000: ALUCtrl = 4'b0010; // ADDI
                            		3'b010: ALUCtrl = 4'b0100; // SLTI
                            		3'b111: ALUCtrl = 4'b0000; // ANDI
                            		3'b110: ALUCtrl = 4'b0001; // ORI
                            		3'b100: ALUCtrl = 4'b0101; // XORI
                            		3'b001: ALUCtrl = 4'b1001; // SLLI
                            		3'b101: ALUCtrl = (instr[30] ? 4'b1010 : 4'b1000); // SRAI or SRLI
                        	endcase
                    	end
                    	7'b0000011: begin // LW
                        	ALUCtrl = 4'b0010; // ADD
				MemToReg = 1; // Write from memory data to register
                    	end
                    	7'b0100011: begin // SW
                        	ALUCtrl = 4'b0010; // ADD
                    	end
                    	7'b1100011: begin // BEQ
                        	ALUCtrl = 4'b0110; // SUB
                    	end
                endcase
            end
            EX: begin	
            	case (instr[6:0])
                	7'b0110011: begin // R-Type
 				ALUSrc = 0;
                	end
			7'b0010011: begin // I-Type
				ALUSrc = 1; // Use immediate
			end
                	7'b0000011, 7'b0100011: begin // LW or SW
                    		ALUSrc = 1; // Use immediate
                	end
                	7'b1100011: begin // BEQ
				ALUSrc = 0;
                    		PCSrc = Zero; 	//Branch if ALU result is zero
                	end
            	endcase
            end
            MEM: begin
                case (instr[6:0])
                    7'b0000011: begin // LW
                        MemRead = 1; // Enable memory read
                    end
                    7'b0100011: begin // SW
                        MemWrite = 1; // Enable memory write
                    end
                endcase
            end
            WB: begin
		MemRead = 0;
		MemRead = 0;
                loadPC = 1; // Load new PC value before transitioning to IF
		RegWrite = 1; // Enable register write
            end
        endcase
    end

endmodule

