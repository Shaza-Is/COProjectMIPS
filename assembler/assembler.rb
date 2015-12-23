#!/usr/bin/env ruby
# -*- ruby -*-

require "./assembler_class"

# Main
unless ARGV.empty?
	f_rel_path = ARGV[0]
	f_abs_path = File.absolute_path f_rel_path
	if File.exist? f_abs_path
		a = Assembler.new f_abs_path
		# begin
			machine_code = a.assemble!
			# creating a file for machine code in the same dir of assembly code file
			machine_code_file_path = File.expand_path("InsMem.list", File.dirname(f_abs_path))
			machine_code_file = File.new(machine_code_file_path, "w+")
			machine_code.each do |byte|
				machine_code_file.puts byte
			end
		# rescue Exception => e
		# 	puts e.message
		# end
	else
		puts "does not exist"
	end
else
	usage = <<EOF
Usage: assembler.exe ASSEMBLY_FILE
This will generate binary code file in the same folder of the ASSEMBLY_FILE"

Supported instructions:
add, addi, lw, sw, sll, and, andi, nor, beq, jal, jr, slt

Example of assembly file format:
================================
# this is an ignored comment
and $s0, $s1, $s2
label: addi $s1, $s2, -2
# another ignored comment
jal label
jr $ra # another allowed comment
sll $t0, $t1, 4
exit:
================================

EOF

	puts usage
end