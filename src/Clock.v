module Clock (clk);
	output clk;
	reg clk;

	always 
		(#5) clk = ~clk;
	end

endmodule