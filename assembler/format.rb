class Format
	include Constants
	attr_reader :string_code
	def initialize code, number, label=nil
		@string_code = code
		@number = number
		@label = label

		@op = /(?<op>[a-z]+)/.match(@string_code)[:op]
		@string_code.gsub!(@op, "").strip!

		@op_code = '%0*b' % [code_lengths[:op_code_length], ops[@op]] # sprintf formatting
		@funct_code = '%0*b' % [code_lengths[:funct_code_length], (functs[@op] ? functs[@op] : 0)]
	end
end

# --------------------------------------------------------------------

class RFormat < Format
	def initialize code, number, label=nil
		super
		unless @op.strip == "jr"
			m = /\$(?<rd>[a-z]+\d?), \$(?<rs>[a-z]+\d?),/.match(@string_code)
			@string_code.gsub!(m.to_s, "").strip!
			@rd_code = '%0*b' % [code_lengths[:rd_code_length], regs[m[:rd]]]
			@rs_code = '%0*b' % [code_lengths[:rs_code_length], regs[m[:rs]]]

			m = /(\$(?<rt>[a-z]+\d?)|(?<shamt>\d+))/.match(@string_code)
			unless m[:rt].nil?
				@rt_code = '%0*b' % [code_lengths[:rt_code_length], regs[m[:rt]]]
				@shamt_code = '%0*b' % [code_lengths[:shamt_code_length], 0]
			else
				@rt_code = '%0*b' % [code_lengths[:rt_code_length], 0]
				@shamt_code = '%0*b' % [code_lengths[:shamt_code_length], m[:shamt]]
			end
		else
			m = /\$(?<rs>[a-z]+\d?)/.match(@string_code)
			@rs_code = '%0*b' % [code_lengths[:rs_code_length], regs[m[:rs]]]
			@rd_code = '%0*b' % [code_lengths[:rd_code_length], 0]
			@rt_code = '%0*b' % [code_lengths[:rt_code_length], 0]
			@shamt_code = '%0*b' % [code_lengths[:shamt_code_length], 0]
		end
	end

	def machine_code
		@op_code + @rs_code + @rt_code + @rd_code + @shamt_code + @funct_code
	end
end

# --------------------------------------------------------------------

class IFormat < Format
	def initialize code, number, label=nil
		super
		m = nil
		case @op.strip
		when "beq"
			m = /\$(?<rt>[a-z]+\d?)\s*,\s*\$(?<rs>[a-z]+\d?)\s*,/.match(@string_code)
			@immed_code = ('%0*b' % [code_lengths[:immed_address_code_length], @label - @number - 1]).gsub(".", "1")
		when "andi", "addi"
			m = /\$(?<rt>[a-z]+\d?)\s*,\s*\$(?<rs>[a-z]+\d?)\s*,\s*(?<immed>-?\d+)/.match(@string_code)
		else # sw and lw
			m = /\$(?<rt>[a-z]+\d?)\s*,\s*\s*(?<immed>-?\d+)\s*\(\$(?<rs>[a-z]+\d?)\)/.match(@string_code)
		end
		@rs_code = '%0*b' % [code_lengths[:rs_code_length], regs[m[:rs]]]
		@rt_code = '%0*b' % [code_lengths[:rt_code_length], regs[m[:rt]]]

		unless @op.strip == "beq"
			@immed_code = ('%0*b' % [code_lengths[:immed_address_code_length], m[:immed]]).gsub(".", "1")
		end
	end

	def machine_code
		@op_code + @rs_code + @rt_code + @immed_code
	end
end

# --------------------------------------------------------------------

class JFormat < Format
	def initialize code, number, label=nil
		super
		@jump_address = '%0*b' % [code_lengths[:j_address_length], @label]
	end

	def machine_code
		@op_code + @jump_address
	end
end
