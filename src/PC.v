module PC(out,in,clk);
	
	input [31:0] in;
	input clk;
	output [31:0] out;
	
	reg [31:0] out;
	wire [31:0] in;
	
	always @ (posedge clk)
		begin
			out = in;
		end
		
	endmodule
		
	