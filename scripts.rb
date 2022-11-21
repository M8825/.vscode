require 'pry-byebug'
require 'tty-command'
# TODO: Doesn't show output for bracketd methodss - FIX

cmd = TTY::Command.new(printer: :null)


# grep args
f_name = ARGV[0]
top_line = ARGV[2].to_i - 30 >= 0 ? ARGV[2].to_i - 30 : 0
bottom_line = ARGV[2].to_i
# grep retrives current method name
cur_method_name = `awk '/def/ && NR >= #{top_line} && NR <= #{bottom_line}' lib/#{f_name}.rb`
parentheses_idx = cur_method_name.split("def")[-1].index("(")
cur_method_name =  'describe "' + '.' + cur_method_name.split("def")[-1][0...parentheses_idx][0..-1].strip + '"'


spec_folder = "#{ARGV[1]}/spec/"
spec_file =  `ls #{spec_folder}*#{f_name}_spec.rb`.split("\n")[0]
function_spec, err = cmd.run(:grep, "-n", cur_method_name, spec_file)
# function_spec = system("grep -n \"describe \".#{cur_method_name}\" #{spec_file}")
line_num = function_spec.split(':')[0].to_i

spec = "#{spec_file}:#{line_num}"
dot_rspec = "#{ARGV[1]}/.rspec"

# binding.pry
puts system("rspec --options #{dot_rspec} #{spec}")