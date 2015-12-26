module shift_left(out, in, shamt);
	output out;
	input in, shamt;
	reg [31:0] out;
	wire [31:0] in;
	wire [4:0] shamt;

	always @ (in or shamt)
	begin
		out <= #2 in << shamt;
	end
endmodule

module shift_left_jump(out, in, shamt);
	output out;
	input in, shamt;
	reg [27:0] out;
	wire [25:0] in;
	wire [4:0] shamt;

	always @ (in or shamt)
	begin
		out <= #2 in << shamt;
	end
endmodule