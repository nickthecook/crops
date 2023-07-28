require "colorize"

class Output
  @@out = STDOUT
  @@err = STDERR
  @@quiet = ENV.fetch("OPS_QUIET_OUTPUT", "false") == "true"

  STATUS_WIDTH = "50"

  OKAY = "OK"
  SKIPPED = "SKIPPED"
  FAILED = "FAILED"

  # used to silence output, e.g. in testing
  class DummyOutput
    def print(*_nope); end

    def puts(*_nope); end
  end

  def self.status(name)
    @@out.print("%-#{STATUS_WIDTH}s " % [name])
  end

  def self.okay
    @@out.puts(OKAY.colorize(:green))
  end

  def self.skipped
    @@out.puts(SKIPPED.colorize(:light_red))
  end

  def self.failed
    @@out.puts(FAILED.colorize(:magenta))
  end

  def self.warn(msg)
    @@err.puts(msg.colorize(:yellow))
  end

  def self.notice(msg)
    return if @@quiet

    warn(msg)
  end

  def self.error(msg)
    @@err.puts(msg.colorize(:red))
  end

  def self.out(msg)
    @@out.puts(msg)
  end

  def self.print(msg)
    @@out.print(msg)
  end

  def self.silence
    @@out = @@err = dummy_output
  end

  def self.dummy_output
    @@dummy_output ||= DummyOutput.new
  end

  def self.debug(msg)
    return unless ENV.fetch("OPS_DEBUG_OUTPUT", "false") == "true"

    @@err.puts(msg.colorize(:blue))
  end

  def self.quiet=(val : Bool)
    @@quiet = val
  end
end
