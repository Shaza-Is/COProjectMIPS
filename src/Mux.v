module mux2x1(out, sel, in0, in1);
	output out;
	input sel, in0, in1;
	wire [31:0] in0, in1;
	reg [31:0] out;
	
	always @ (sel)
	begin
		if(sel == 0)
			out <= in0;
		else
			out <= in1;
	end
	
endmodule
