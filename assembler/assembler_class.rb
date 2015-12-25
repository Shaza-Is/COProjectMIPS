require "./constants"
require "./format"

class Assembler
	include Constants

	def initialize abs_path
		@file_abs_path = abs_path
	end

	def assemble!
		split_text_and_data!
		sanitize!
		extract_labels!
		categorize!
		machinize!
	end

	private
	def split_text_and_data!
		@assembly_code_lines = []

		line_num = 0
		@is_in_data = false

		IO.readlines(@file_abs_path).each do |l|
			line_num += 1

			if  /\.data/ =~ l
				@is_in_data = true
				next
			elsif /\.text/ =~ l
				@is_in_data = false
				next
			end

			unless @is_in_data
				@assembly_code_lines << [l, line_num, 'text']
			else
				@assembly_code_lines << [l, line_num, 'data']
			end
		end
		puts "Text segment lines:"
		@assembly_code_lines.each {|l| p l if l[2] == 'text' }
		puts "========================="
		puts "Data segment lines:"
		@assembly_code_lines.each {|l| p l if l[2] == 'data'}
		puts "========================="
	end

	def sanitize!
		@assembly_code_lines_sanitized = []
		@data_code_lines_sanitized = []
		@assembly_code_lines.each do |line_info|
			l = line_info[0]
			line_num = line_info[1]
			seg_type = line_info[2]
			# removing comments and empty lines
			if hash_index = l.index("#")
				l = l[0...hash_index]
			end
			l.strip!
			next if l.empty?

			check_syntax l, line_num, seg_type

			@assembly_code_lines_sanitized << l if seg_type == 'text'
			@data_code_lines_sanitized << l if seg_type == 'data'
		end
		puts "Sanitized assembly segment lines:"
		@assembly_code_lines_sanitized.each {|l| puts "  #{l}"}
		puts "========================="
		puts "Sanitized data segment lines:"
		@data_code_lines_sanitized.each {|l| puts "  #{l}"}
		puts "========================="
	end

	def extract_labels!
		@labels = {}
		@assembly_code_lines_sanitized.each_with_index do |c, i|
			if m = /(?<label>[A-z]\w*):\s*/.match(c)
				@labels[m[:label]] = i # putting label with instruction number in a hash
				@assembly_code_lines_sanitized[i] = c.gsub(m[:label], "")
			end
		end
		puts "Extracted labels hash:"
		puts @labels
		puts "========================="
	end

	def categorize!
		@categorized_code = []
		puts "Assembly code categorization:"
		@assembly_code_lines_sanitized.each_with_index do |c, c_ind|
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
					puts "  #{inst.class}"
					break
				end
			end
		end
		puts "========================="
	end

	def machinize!
		@instruction_code, @data_code = [], []

		@categorized_code.each do |code|
			@instruction_code << code.machine_code.chars.each_slice(8).map(&:join)
		end

		@data_code_lines_sanitized.each do |code|
			m = /^\.word\s+(?<numbers>-?\d+(\s*,\s*-?\d+)*)$/.match(code)
			m[:numbers].split(",").map(&:strip).each do |num|
				@data_code << ('%0*b' % [32, num]).gsub(".", "1").chars.each_slice(8).map(&:join)
			end
		end
		[@instruction_code, @data_code]
	end

	def check_syntax l, line_num, type
		if type == 'data'
			unless /^\.word\s+-?\d+(\s*,\s*-?\d+)*$/ =~ l
				raise "Syntax error at line #{line_num}: #{l}"
			end
		else
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
end
