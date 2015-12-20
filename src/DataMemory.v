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
	input mem_write
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
			#25 data <= {mem[address], mem[address+1], mem[address+2], mem[address+3]};
	end
	
	always @(mem_write or address or write_data) begin
		if(mem_write)
			#25 {mem[address], mem[address+1], mem[address+2], mem[address+3]} = write_data;
	end
endmodule