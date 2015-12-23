module PC(out,in,clk);

	input [31:0] in;
	input clk;
	output [31:0] out;
	
	reg [31:0] out;
	wire [31:0] in;
	reg reset;
	initial begin
		reset = 1;
	    #51 reset = 0;
	end
	
	always @ (posedge clk)
	begin
		if(reset)
			out <= #2 0;
		else
			out <= #2 in;		
	end
		
endmodule
