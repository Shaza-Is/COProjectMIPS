require "./assembler_class"
# Main
unless ARGV.empty?
	f_rel_path = ARGV[0]
	f_abs_path = File.absolute_path f_rel_path
	if File.exist? f_abs_path
		a = Assembler.new f_abs_path
		# begin
			a.assemble!
		# rescue Exception => e
		# 	puts e.message
		# end
	else
		puts "does not exist"
	end
else
	puts "Empty arguments,, print usage"
end