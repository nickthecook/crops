require "colorize"

class Output
  @@out = STDOUT
  @@err = STDERR

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
    @@err.puts(msg.colorize(:light_red))
  end

  def self.notice(msg)
    warn(msg)
  end

  def self.error(msg)
    @@err.puts(msg.colorize(:magenta))
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
    return unless ENV.keys.includes?("OPS_DEBUG_OUTPUT") && ENV["OPS_DEBUG_OUTPUT"] == "true"

    @@err.puts(msg.colorize(:blue))
  end
end
