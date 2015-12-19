module MIPS();
reg clk;

// PC
wire [31:0] pc_address_in, pc_address_out;
PC program_counter(pc_address_out, pc_address_in, clk); // bayza

// Instruction memory
wire [31:0] instruction;
InstructionMemory ins_mem(instruction, pc_address_out);

// Adder PC + 4
parameter pc_increment_amount = 4;
wire [31:0] next_pc_address;
adder_32bit pc_adder(next_pc_address, pc_address_out, pc_increment_amount);

// Control unit
wire [1:0] cu_reg_dst, cu_mem_to_reg, cu_alu_op;
wire cu_branch, cu_mem_read, cu_mem_write, cu_alu_src, cu_reg_write, cu_jump, cu_arith;
ControlUnit cu(instruction[31:26] /* op_code */, cu_reg_dst, cu_branch, cu_mem_read,
	       cu_mem_to_reg, cu_alu_op, cu_mem_write, cu_alu_src, cu_reg_write, cu_jump, cu_arith);

// Register destination mux
wire [31:0] write_reg_address;
parameter ra = 31;
mux_4x1 mx1(write_reg_address, cu_reg_dst, instruction[20:16] /* rt */, instruction[15:11] /* rd */, ra);

// Shift left jump address by 2
wire [27:0] jump_address_shifted;
wire [31:0] jump_address;
parameter jump_shift_amount = 2;
shift_left sll1(jump_address_shifted, instruction[25:0] /* Jump least significant */, jump_shift_amount);
assign jump_address = {next_pc_address[31:28], jump_address_shifted};

// Sign extend
wire [31:0] immediate_extended;
signExtender_16to32 se(immediate_extended, instruction[15:0] /* immediate value */, cu_arith);

// Register file
wire [31:0] rs, rt, write_reg_data;
wire Jreg_not, Jreg, reg_write;
not(Jreg_not, Jreg);
and(reg_write, cu_reg_write, Jreg_not);
regFile reg_file(rs, rt, reg_write, clk, instruction[25:21] /* rs address */,
				 instruction[20:16] /* rt address */, write_reg_address, write_reg_data);



endmodule
