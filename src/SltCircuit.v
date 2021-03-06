module slt_32bit(out, a, b);
	output out;
	input a, b;
	reg [31:0] out;
	wire [31:0] a, b;

	always @ (a or b)
	begin
		if(a < b)
			out <= #2 32'h00000001;
		else
			out <= #2 32'h00000000;
	end
endmodule
