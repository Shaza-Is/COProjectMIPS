class Format
	include Constants
	# @op_code
	attr_writer :label
	def initialize code
		@string_code = code
		@op = /(?<op>[a-z]+)/.match(@string_code)[:op]
		@string_code.gsub!(@op, "").strip!
		@op_code = '%0*b' % [code_lengths[:op_code_length], ops[@op]] # sprintf formatting
		@funct_code = '%0*b' % [code_lengths[:funct_code_length], functs[@op]]
		@is_jr = true if @op.strip == "jr"
	end
end

# --------------------------------------------------------------------

class RFormat < Format
	def initialize code
		super
		unless @is_jr
			m = /\$(?<rd>[a-z]+\d?), \$(?<rt>[a-z]+\d?),/.match(@string_code)
			@string_code.gsub!(m.to_s, "").strip!
			@rd_code = '%0*b' % [code_lengths[:rd_code_length], regs[m[:rd]]]
			@rt_code = '%0*b' % [code_lengths[:rt_code_length], regs[m[:rt]]]

			m = /(\$(?<rs>[a-z]+\d?)|(?<shamt>\d+))/.match(@string_code)
			unless m[:rs].nil?
				@rs_code = '%0*b' % [code_lengths[:rs_code_length], regs[m[:rs]]]
				@shamt_code = '%0*b' % [code_lengths[:shamt_code_length], 0]
			else
				@rs_code = '%0*b' % [code_lengths[:rs_code_length], 0]
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
	def initialize code
		super
	end

	def machine_code
		puts "TODO"
	end
end

# --------------------------------------------------------------------

class JFormat < Format
	def initialize code
		super
	end

	def machine_code
		puts "TODO"
	end
end
