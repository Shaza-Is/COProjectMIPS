module Constants
	code_formats = {
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

	op_code_length = 6
	ops = {
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

	funct_code_length = 6
	functs = {
		'add' => 32,
		'sll' => 0,
		'and' => 36,
		'nor' => 39,
		'jr' => 8,
		'slt' => 42
	}

	rs_code_length = 5
	rt_code_length = 5
	rd_code_length = 5
	shamt_code_length = 5
end

# --------------------------------------------------------------------

class Format
	# @op_code

	def initialize code
		@string_code = code
	end
end

# --------------------------------------------------------------------

class TwoRegFormat < Format
	# @rs, @rt

	def initialize code
		super
	end
end

# --------------------------------------------------------------------

class RFormat < TwoRegFormat
	# @rd, @shamt, @funct

	def initialize code
		@string_code = code
		super
	end
end

# --------------------------------------------------------------------

class IFormat < TwoRegFormat

end

# --------------------------------------------------------------------

class JFormat < Format
end

# --------------------------------------------------------------------

class Assembler
	def initialize abs_path
		@file_abs_path = abs_path
	end

	def assemble!
		sanitize!
		categorize!
		machinize!
	end

	private
	def sanitize!
		@assembly_code_lines = []
		line_num = 0
		IO.readlines(@file_abs_path).each do |l|
			line_num += 1
			# removing comments and empty lines
			if hash_index = l.index("#")
				l = l[0...hash_index]
			end
			l.strip!
			next if l.empty?

			unless /^(add|and|or|slt|nor)\s+\$([s][0-7]|t[0-9])\s*,\s*\$(s[0-7]|t[0-9]|zero)\s*,\s*\$(s[0-7]|t[0-9]|zero)$/ =~ l or
						 /^(lw|sw)\s+\$(s[0-7]|t[0-9])\s*,\s*[0-9]{1,5}\s*\(\$(s[0-7]|t[0-9]|zero)\)$/ =~ l or
						 /^(sll|addi|andi)\s+\$(s[0-7]|t[0-9])\s*,\s*\$(s[0-7]|t[0-9])\s*,\s*[0-9]{1,5}$/ =~ l
				raise "Syntax error at line #{line_num}: #{l}"
			end

			@assembly_code_lines << l
		end
	end

	def categorize!
		@categorized_code = []
		@assembly_code_lines.each do |c|
			c.index(" ")
		end
	end

	def machinize!
	end
end

# --------------------------------------------------------------------

# Main
unless ARGV.empty?
	f_rel_path = ARGV[0]
	f_abs_path = File.absolute_path f_rel_path
	if File.exist? f_abs_path
		a = Assembler.new f_abs_path
		begin
			a.assemble!
		rescue Exception => e
			puts e.message
		end
	else
		puts "does not exist"
	end
else
	puts "Empty arguments,, print usage"
end