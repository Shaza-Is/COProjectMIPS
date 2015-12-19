module Clock (clk);
	output clk;
	reg clk;
	
	initial begin
		clk <= 0;
	end
	always begin 
		#5 clk <= ~clk;
	end

endmodule