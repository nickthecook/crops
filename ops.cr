require "colorize"

require "ops"

options = {
  "config_file" => "ops.yml"
}

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

    options["config_file"] = ARGV.shift
  else
    usage
  end
end

Ops.new(ARGV, config_file: options["config_file"]).run
