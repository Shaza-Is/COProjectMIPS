#!/usr/bin/env ruby
# -*- ruby -*-

require "./assembler_class"

# Main
unless ARGV.empty?
	f_rel_path = ARGV[0]
	f_abs_path = File.absolute_path f_rel_path
	if File.exist? f_abs_path
		a = Assembler.new f_abs_path
		begin
			instruction_code, data_code = a.assemble!
			# creating a file for machine code in the same dir of assembly code file
			unless instruction_code.empty?
				instruction_code_file_path = File.expand_path("InsMem.list", File.dirname(f_abs_path))
				instruction_code_file = File.new(instruction_code_file_path, "w+")
				instruction_code.each do |byte|
					instruction_code_file.puts byte
				end
				puts "Wrote instruction memory file: \"#{instruction_code_file_path}\""
			else
				puts "No instruction code generated, Nothing to write in file!"
			end

			unless data_code.empty?
				data_code_file_path = File.expand_path("DataMem.list", File.dirname(f_abs_path))
				data_code_file = File.new(data_code_file_path, "w+")
				data_code.each do |byte|
					data_code_file.puts byte
				end
				puts "Wrote Instruction memory file: \"#{data_code_file_path}\""
			else
				puts "No data code generated, Nothing to write in file!"
			end
		rescue Exception => e
			puts e.message
		end
	else
		puts "does not exist"
	end
else
	usage = <<EOF
Usage: assembler.exe ASSEMBLY_FILE
This will generate binary code file in the same folder of the ASSEMBLY_FILE

Supported instructions:
add, addi, lw, sw, sll, and, andi, nor, beq, jal, jr, slt

Supported Data types:
.word

Example of assembly file format:
================================
.text
# this is an ignored comment
and $s0, $s1, $s2
label: addi $s1, $s2, -2
# another ignored comment
jal label
jr $ra # another allowed comment
sll $t0, $t1, 4
exit:
.data
.word 12, 14
.word 15
================================
NOTE: labels are not supported in data segment, it will raise a syntax error
EOF

	puts usage
end