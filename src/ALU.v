/**
inputs:
 ALUControl: (4 bits)
 and: 0000
 add: 0010
 sub: 0110
 slt: 0111
 nor: 1100
 sll: 1110

 shamt: shift amount (5 bits)
 rs: register 1
 rt: register 2 or immediate 32-bit sign extended value

outputs:
 zero: 1 if rs-rt = 0
 result: depends on ALUControl
 */


module ALU(result, zero, rs, rt, shamt, ALUControl);
	input rs, rt, shamt, ALUControl;
	output result, zero;
	wire [31:0] rs, rt;
	wire [4:0] shamt;
	wire [3:0] ALUControl;
	reg [31:0] result;
	wire [31:0] add_res, sub_res, sll_res, and_res, nor_res, slt_res;
	reg zero;

	parameter AND = 0, ADD = 2, SUB = 6, SLT = 7, NOR = 12, SLL = 14;
	
	adder_32bit  ALU_ADD(add_res, rs, rt);
	sub_32bit  ALU_SUB(sub_res, rs, rt);
	shift_left  ALU_SLL(sll_res, rt, shamt);
	and_32bit  ALU_AND(and_res, rs, rt);
	nor_32bit  ALU_NOR(nor_res, rs, rt);
	slt_32bit  ALU_SLT(slt_res, rs, rt);

	initial 
	begin
		zero = 0;
		result = 0;
	end
	
	always @(sub_res)
	begin
		if(sub_res == 32'h00000000)
			zero <= 1;
		else
			zero <= 0;
	end

	always @ (ALUControl, rs, rt, shamt)	
	begin
	case(ALUControl)
		AND: 
			result <= and_res;
		ADD:
			result <= add_res;
		SUB:
			result <= sub_res;
		SLT:
			result <= slt_res;
		NOR:
			result <= nor_res;
		SLL:
			result <= sll_res;
	endcase	
	end

endmodule
