module Clock (clk);
	output clk;
	reg clk;
	
	initial begin
		clk <= 0;
	end
	always begin 
		#40 clk <= ~clk;
	end

endmodule