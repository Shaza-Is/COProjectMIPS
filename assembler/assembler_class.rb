require "./constants"
require "./format"

class Assembler
	include Constants

	def initialize abs_path
		@file_abs_path = abs_path
	end

	def assemble!
		sanitize!
		extract_labels!
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

			check_syntax l, line_num

			@assembly_code_lines << l
		end
	end

	def extract_labels!
		@labels = {}
		@assembly_code_lines.each_with_index do |c, i|
			if m = /(?<label>[A-z]\w*):\s*/.match(c)
				@labels[m[:label]] = i # putting label with instruction number in a hash
				@assembly_code_lines[i] = c.gsub(m[:label], "")
			end
		end
	end

	def categorize!
		@categorized_code = []
		@assembly_code_lines.each_with_index do |c, c_ind|
			code_formats.keys.each do |f|
				if Regexp.new("\\b" + f + "\\b") =~ c
					found_label = nil
					@labels.keys.each do |label|
						 if c.include? label
						 	found_label = @labels[label]
						 end
					end
					inst = Object.const_get(code_formats[f] + "Format").new(c,c_ind,found_label)
					@categorized_code << inst
					break
				end
			end
		end
	end

	def machinize!
		@machine_code = []
		@categorized_code.each do |code|
			@machine_code << code.machine_code.chars.each_slice(8).map(&:join)
		end
		@machine_code
	end

	def check_syntax l, line_num
		regs_ord = regs.keys.join("|")
		unless /^([A-z]\w*:\s*)?(add|and|slt|nor)\s+\$(#{regs_ord})\s*,\s*\$(#{regs_ord})\s*,\s*\$(#{regs_ord})$/ =~ l or
					 /^([A-z]\w*:\s*)?(lw|sw)\s+\$(#{regs_ord})\s*,\s*([0-9]{1,5})\s*\(\$(#{regs_ord})\)$/ =~ l or
					 /^([A-z]\w*:\s*)?(sll|addi|andi)\s+\$(#{regs_ord})\s*,\s*\$(#{regs_ord})\s*,\s*-?[0-9]{1,5}$/ =~ l or
					 /^([A-z]\w*:\s*)?(beq)\s+\$(#{regs_ord})\s*,\s*\$(#{regs_ord})\s*,\s*([A-z]\w*)$/ =~ l or
					 /^([A-z]\w*:\s*)?(jal)\s+([A-z]\w*)\s*$/ =~ l or
					 /^([A-z]\w*:\s*)?(jr)\s+\$(#{regs_ord})$/ =~ l or
					 /^([A-z]\w*:)$/ =~ l
			raise "Syntax error at line #{line_num}: #{l}"
		end
	end
end
