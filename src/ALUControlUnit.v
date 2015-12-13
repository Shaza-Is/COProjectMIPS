/**
 inputs:
	ALUop: 
		lw, sw, addi = 00
		beq = 01
		R-Format = 10
		Andi = 11
	Function: (Required)
		ADD: 100000 
		AND: 100100 
		SLT: 101010
		NOR: 100111
		JR: 001000
		SLL: 000000
	
 */
module ALU_Control_Unit(ALUControl, Jr, ALUop, Function);
	input ALUop, Function;
	output ALUControl, Jr; 
	wire [5:0] Function;
	wire [1:0] ALUop;
	reg [3:0] ALUControl, FunctionRes;
	reg Jr;
	
	parameter LW_SW_ADDI = 0, BEQ = 1, R_FORMAT = 2, ANDI = 3;
	parameter ADD = 32, AND = 36, SLT = 42, NOR = 39, JR = 8, SLL = 0;

	initial 
	begin
		Jr <= 0;
		ALUControl <= 4'b1111;
	end

	// handles function control
	always @ (Function)
	begin
	case(Function)
		ADD:
			FunctionRes <= 4'b0010;
		AND:
			FunctionRes <= 4'b0000;
		SLT:
			FunctionRes <= 4'b0111;
		NOR:
			FunctionRes <= 4'b1100;
		SLL:
			FunctionRes <= 4'b1110;
		JR: begin
			if(ALUop == R_FORMAT)
				Jr <= 1;
			else
				Jr <= 0;
			FunctionRes <= 4'b1111;
		end
	endcase
	end

	always @ (ALUop, FunctionRes)
	begin
	case(ALUop)
		LW_SW_ADDI:
			ALUControl <= 4'b0010;
		BEQ:
			ALUControl <= 4'b0110;
		R_FORMAT:
			ALUControl <= FunctionRes;
		ANDI:
			ALUControl <= 4'b0000;
	endcase
	end
endmodule

