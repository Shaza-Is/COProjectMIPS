//-----------------------------------------------------------------------------
//
// Title       : InstructionMemory
// Design      : MIPS processor
// Author      : Mohamed Anwer
//
//-----------------------------------------------------------------------------
//
// File        : InstructionMemory.v
// Generated   : Sat Dec 12 22:29:22 2015
// From        : interface description file
// By          : Itf2Vhdl ver. 1.22
//
//-----------------------------------------------------------------------------
//
// Description : Instruction Memory module
//
//-----------------------------------------------------------------------------

module InstructionMemory (
	output reg [31:0] instruction, 
	input [31:0] address
);	
	reg [7:0] mem [0:255];	
	integer i = 0;
	
	initial begin 					  
		for ( i=0; i < 256 ; i=i+1) begin
			mem[i] <= 8'b00000000;
		end	   
		#1
		$readmemb("InsMem.list", mem);
	end								  
	
	always @(address) begin
		instruction <= #20 {mem[address], mem[address+1], mem[address+2], mem[address+3]};
		if(instruction == 8'hxxxxxxxx || instruction == 8'h00000000 )
			$finish(); // stops the simulation when program is finished
	end
endmodule
