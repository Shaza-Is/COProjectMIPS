module mux_2x1(out, sel, in0, in1);
	output out;
	input sel, in0, in1;
	wire [31:0] in0, in1;
	reg [31:0] out;
	
	always @ (sel or in0 or in1)
	begin
		if(sel == 0)
			#2 out = in0;
		else
			#2 out = in1;
	end
	
endmodule

/* just in case */
module mux_4x1(out, sel, in0, in1, in2, in3);
	output out;
	input sel, in0, in1, in2, in3;
	wire [31:0] in0, in1, in2, in3;
	wire [1:0] sel;
	reg [31:0] out;
	
	always @ (sel or in0 or in1 or in2)
	begin
		if(sel == 0)
			#2 out = in0;
		else if(sel == 1)
			#2 out = in1;
		else if(sel == 2)
			#2 out = in2;
		else
			#2 out = in3;
	end
	
endmodule

module mux_4x1_5bits(out, sel, in0, in1, in2, in3);
	output out;
	input sel, in0, in1, in2, in3;
	wire [4:0] in0, in1, in2, in3;
	wire [1:0] sel;
	reg [4:0] out;
	
	always @ (sel or in0 or in1 or in2)
	begin
		if(sel == 0)
			#2 out = in0;
		else if(sel == 1)
			#2 out = in1;
		else if(sel == 2)
			#2 out = in2;
		else
			#2 out = in3;
	end
	
endmodule
