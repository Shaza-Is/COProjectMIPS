module signExtender_16to32(out, in);
	input in;
	output out;
	wire [15:0] in;
	wire [31:0] out;
	
	assign out = { {16{in[15]}},in[15:0] };
endmodule
