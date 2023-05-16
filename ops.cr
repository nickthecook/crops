require "colorize"

require "ops"

def usage
  STDERR.puts "Usage: ops [-f <filename>] <action>".colorize(:red)
  exit(1)
end

usage if ARGV.empty?

while ARGV.first =~ /^-/
  opt = ARGV.shift

  case opt
  when "-f", "--file"
    usage if ARGV.empty?

    config_file = ARGV.shift
  else
    usage
  end
end

exit Ops.new(ARGV, config_file: config_file).run ? 0 : 1
