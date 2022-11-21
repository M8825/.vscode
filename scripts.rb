require 'pry-byebug'
require 'tty-command'
# TODO: Doesn't show output for bracketd methodss - FIX


# run cli command wihtout any output
cmd = TTY::Command.new(printer: :null)


# grep args
f_name = ARGV[0]
top_line = ARGV[2].to_i - 30 >= 0 ? ARGV[2].to_i - 30 : 0
bottom_line = ARGV[2].to_i

# egrep retrives current method name
# build arguments fork egrep -n 

# Get method nume above cursor from active lib/*.rb file
rspec_search_line = `awk '/def/ && NR >= #{top_line} && NR <= #{bottom_line}' lib/#{f_name}.rb`.split("def")[-1]
# Get rid of the parentheses and arguments after method name from lib/ file
rspec_search_line = rspec_search_line[0...rspec_search_line.index("(")].strip

# Construct arguments part for regex. Match describe "method_name" in spec file
rspec_search_line =  'describe "' + '#?' + rspec_search_line + '[!?]?.*"'


#  
spec_file = "#{ARGV[1]}/spec/*" + f_name + '_spec.rb'
spec_file_path = `ls -la #{spec_file}`.split(' ')[-1].strip
function_spec, err = cmd.run(:egrep, "-n", rspec_search_line, spec_file_path)
# function_spec = system("grep -n \"describe \".#{cur_method_name}\" #{spec_file}")
line_num = function_spec.split(':')[0].to_i

spec = "#{spec_file_path}:#{line_num}"
dot_rspec = "#{ARGV[1]}/.rspec"

puts system("rspec --options #{dot_rspec} #{spec}")