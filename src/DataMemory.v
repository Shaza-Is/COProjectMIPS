//-----------------------------------------------------------------------------
//
// Title       : DataMemory
// Design      : MIPS
// Author      : Mohamed Anwer
//
//-----------------------------------------------------------------------------
//
// File        : DataMemory.v
// Generated   : Fri Dec 18 12:23:08 2015
// From        : interface description file
// By          : Itf2Vhdl ver. 1.22
//
//-----------------------------------------------------------------------------
//
// Description : Data memory module
//
//-----------------------------------------------------------------------------

module DataMemory (
	output reg [31:0] data,
	input [31:0] address,
	input [31:0] write_data,
	input mem_read,
	input mem_write,
	input clk
);	
	reg [7:0] mem [0:2047];
	integer file;
	parameter file_name = "DataMem.list"; 
	integer i;

	initial begin 					  
		for ( i=0; i < 2048 ; i=i+1) begin
			mem[i] <= 8'b00000000;
		end	   
		#1
		$readmemb(file_name, mem);
	end
	
	always @(mem_read or address) begin
		if(mem_read)
			data <= #20 {mem[address], mem[address+1], mem[address+2], mem[address+3]};
	end
	
	always @(posedge clk) begin
		if(mem_write)
			{mem[address], mem[address+1], mem[address+2], mem[address+3]} <= #20 write_data;
	end
endmodule