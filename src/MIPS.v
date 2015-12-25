module MIPS();

// Clock
wire clk;
Clock c(clk);

// PC
wire [31:0] pc_address_in, pc_address_out;
PC program_counter(pc_address_out, pc_address_in, clk); 

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
wire [4:0] write_reg_address, w_ignored1;
parameter ra = 5'b11111; // ra = 32
mux_4x1_5bits mx1(write_reg_address, cu_reg_dst, instruction[20:16] /* rt */, instruction[15:11] /* rd */, ra, w_ignored1);

// Shift left jump address by 2
wire [27:0] jump_address_shifted;
parameter jump_shift_amount = 5'b00010; // shift amount = 2
shift_left_jump sll1(jump_address_shifted, instruction[25:0] /* Jump least significant */, jump_shift_amount);

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

// ALU source mux
wire [31:0] alu_input2;
mux_2x1 mx2(alu_input2, cu_alu_src, rt, immediate_extended);

// Shift left branch by 2 
wire [31:0] branch_address_shifted;
parameter branch_shift_amount = 5'b00010; // shift amount = 2
shift_left sll2(branch_address_shifted, immediate_extended, branch_shift_amount);

// ALU Control Unit
wire [3:0] alu_control;
ALU_Control_Unit alu_cu(alu_control, Jreg, cu_alu_op, instruction[5:0] /* function */);

// ALU
wire [31:0] alu_result;
wire alu_zero;
ALU alu(alu_result, alu_zero, rs, alu_input2, instruction[10:6] /* shamt */, alu_control);

// Adder
wire [31:0] final_branch_address;
adder_32bit branch_adder(final_branch_address,next_pc_address, branch_address_shifted);

// Branch And
wire branch_address_selector;
and(branch_address_selector,cu_branch,alu_zero);

//Branch mux
wire [31:0] mux_branch_output;
mux_2x1 Branch_mux(mux_branch_output, branch_address_selector, next_pc_address, final_branch_address);

//Jump mux
wire [31:0] mux_jump_output;
mux_2x1 jump_mux(mux_jump_output, cu_jump, mux_branch_output, {next_pc_address[31:28], jump_address_shifted} /*concatenation*/);

//Jreg mux
mux_2x1 jreg_mux(pc_address_in, Jreg, mux_jump_output, rs);

//Data_memory
wire [31:0] data_mem_out;
DataMemory data_memory(data_mem_out, alu_result, rt, cu_mem_read, cu_mem_write, clk);

//Memory output mux
wire [31:0] w_ignored2;
mux_4x1 mx3(write_reg_data, cu_mem_to_reg, alu_result, data_mem_out, next_pc_address, w_ignored2);
endmodule
