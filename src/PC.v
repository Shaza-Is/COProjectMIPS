module PC(out,in,clk);

	input [31:0] in;
	input clk;
	output [31:0] out;
	
	reg [31:0] out;
	wire [31:0] in;
	reg reset;
	initial begin
		reset = 1;
	    #6 reset = 0;
	end
	
	always @ (posedge clk)
	begin
		if(reset)
			out <= 0;
		else
			out <= in;		
	end
		
endmodule
		
module test();
	wire clk;  
	wire [31:0] out;
	reg [31:0] in;
	initial begin
		in = 0;
	end
	Clock c(clk);
	PC pc(out,in,clk);
endmodule
