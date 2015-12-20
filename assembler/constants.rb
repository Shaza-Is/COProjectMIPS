module Constants
	def code_formats
		{
			'add' => 'R',
			'addi' => 'I',
			'lw' => 'I',
			'sw' => 'I',
			'sll' => 'R',
			'and' => 'R',
			'andi' => 'I',
			'nor' => 'R',
			'beq' => 'I',
			'jal' => 'J',
			'jr' => 'R',
			'slt' => 'R'
		}
	end

	def ops
		{
			'add' => 0,
			'addi' => 8,
			'lw' => 35,
			'sw' => 43,
			'sll' => 0,
			'and' => 0,
			'andi' => 12,
			'nor' => 0,
			'beq' => 4,
			'jal' => 3,
			'jr' => 0,
			'slt' => 0
		}
	end

	def functs
		{
			'add' => 32,
			'sll' => 0,
			'and' => 36,
			'nor' => 39,
			'jr' => 8,
			'slt' => 42
		}
	end

	def code_lengths
		{
			op_code_length: 6,
			rs_code_length: 5,
			rt_code_length: 5,
			rd_code_length: 5,
			shamt_code_length: 5,
			funct_code_length: 6
		}
	end

	def regs
		regs = {}
		regs['zero'] = 0
		regs['at'] = regs.values.last + 1
		(0..1).each {|num| regs["v" + num.to_s] =  regs.values.last + 1}
		(0..3).each {|num| regs["a" + num.to_s] =  regs.values.last + 1}
		(0..7).each {|num| regs["t" + num.to_s] =  regs.values.last + 1}
		(0..7).each {|num| regs["s" + num.to_s] =  regs.values.last + 1}
		(8..9).each {|num| regs["t" + num.to_s] =  regs.values.last + 1}
		(0..1).each {|num| regs["k" + num.to_s] =  regs.values.last + 1}
		regs['gp'] = regs.values.last + 1
		regs['sp'] = regs.values.last + 1
		regs['fp'] = regs.values.last + 1
		regs['ra'] = regs.values.last + 1
		regs
	end
end