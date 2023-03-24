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
    @@out.print("%-#{STATUS_WIDTH}<name>s " % {name: name})
  end

  def self.okay
    @@out.puts(OKAY.colorize(:green))
  end

  def self.skipped
    @@out.puts(SKIPPED.colorize(:yellow))
  end

  def self.failed
    @@out.puts(FAILED.colorize(:red))
  end

  def self.warn(msg)
    @@err.puts(msg.colorize(:yellow))
  end

  def self.notice(msg)
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
end
