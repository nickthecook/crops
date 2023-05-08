require "colorize"

require "ops"

CONFIG_FILES = ["ops.yaml", "ops.yml"]

options = {
  "config_file" => CONFIG_FILES.find { |file| File.exists?(file) }
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

exit Ops.new(ARGV, config_file: options["config_file"]).run ? 0 : 1
