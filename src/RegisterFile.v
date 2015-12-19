module regFile(readDat1, readDat2, regWrite, clk, readReg1, readReg2, writeReg, writeData);
	input writeData, writeReg, readReg1, readReg2, clk, regWrite;
	output readDat1, readDat2;

	wire [31:0] readDat1;
	wire [31:0] readDat2;
	reg [31:0] registers [0:31];
	wire [4:0] readReg1;
	wire [4:0] readReg2;
	wire [4:0] writeReg;
	wire regWrite, clk;
	integer i;
	initial begin
		for(i = 0; i < 32; i = i + 1)
		begin
			registers[i] <= 0;
		end
	end

	assign readDat1 = registers[readReg1];
	assign readDat2 = registers[readReg2];

	always @(posedge clk) begin 
		if(regWrite && writeReg) begin
			registers[writeReg] = writeData;
		end	
	end

endmodule