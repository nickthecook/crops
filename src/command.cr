class Command
  def self.capture3(cmd) : Tuple(Int32, String, String)
    stdout = IO::Memory.new
    stderr = IO::Memory.new
    status = Process.run(cmd, shell: true, output: stdout, error: stderr)

    {status.exit_code, stdout.to_s, stderr.to_s}
  end
end
