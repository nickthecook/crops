require "colorize"

require "ops"

def usage
  STDERR.puts Builtins::Help.usage(:error)
  exit(1)
end

usage if ARGV.empty?

# Enforce `--quiet` to act on a per-call basis.
ENV.delete("OPS_QUIET_OUTPUT")

while ARGV.first =~ /^-/
  opt = ARGV.first

  case opt
  when "-f", "--file"
    ARGV.shift
    usage if ARGV.empty?

    config_file = ARGV.shift
  when "-q", "--quiet"
    ARGV.shift
    ENV["OPS_QUIET_OUTPUT"] = "true"
  else
    break
  end
end

exit Ops.new(ARGV, config_file: config_file).run ? 0 : 1
