module signExtender_16to32(out, in, Arith);
	input in, Arith;
	output out;
	wire [15:0] in;
	wire [31:0] out;
	wire Arith;
	// sign extend if arthimatic operation
	// concatenate 16 zero if logical operation
	assign out = Arith? { {16{in[15]}},{in[15:0]} } : { {16{1'b0}},{in[15:0]} };
endmodule
