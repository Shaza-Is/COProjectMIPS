module shift_left(out, in, shamt);
	output out;
	input in, shamt;
	reg [31:0] out;
	wire [31:0] in;
	wire [4:0] shamt;

	always @ (in or shamt)
	begin
		out = in << shamt;
	end
endmodule
