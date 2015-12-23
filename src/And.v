module and_32bit(out, a, b);
	output out;
	input a, b;
	reg [31:0] out;
	wire [31:0] a, b;

	always @ (a or b)
	begin
		out <= #2 a & b;
	end
endmodule
