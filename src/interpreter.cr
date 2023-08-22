
struct Interpreter
  ENV_SPLIT = "-S"

  @@shell : String | Nil

  protected def self.shell : String
    {% if flag?(:darwin) %}
      @@shell ||= begin
        Process.find_executable(ENV.fetch("RUBYSHELL", "dash")).as(String)
      rescue TypeCastError
        Process.find_executable("sh").as(String)
      end
    {% else %}
      @@shell ||= Process.find_executable(ENV.fetch("RUBYSHELL", "sh")).as(String)
    {% end %}
  end

  # Ripped from Crystal::System::FileDescriptor#pipe, except we don't want `reader` to close-on-exec.
  protected def self.pipe(command : String) : {IO::FileDescriptor, IO::FileDescriptor}
    pipe_fds = uninitialized StaticArray(LibC::Int, 2)
    raise IO::Error.from_errno("Could not create pipe") if LibC.pipe(pipe_fds) != 0

    reader = IO::FileDescriptor.new(pipe_fds[0], false)
    writer = IO::FileDescriptor.new(pipe_fds[1], false)
    writer.close_on_exec = true
    writer.sync = true
    writer << command

    {reader, writer}
  end

  # Ditto, except we only yield the path.
  protected def self.pipe(command : String, &)
    reader, writer = pipe(command)

    begin
      yield "/dev/fd/#{reader.fd}"
    ensure
      writer.flush
      reader.close
      writer.close
    end
  end

  #######################################################################################

  getter :name, :options, :code

  @name : String = shell
  @options : Array(String) = [] of String
  @code : String = ""

  def initialize(content : String)
    match = /(\A#!.+\n|)([\S\s]*)\Z/.match(content).as(Regex::MatchData)
    shebang = Process.parse_arguments(match[1])
    shebang << self.class.shell unless shebang.any?

    self.parse(shebang)
    @code = match[2]
  end

  def exec(args : Array(String))
    exit 0 if noop?

    self.class.pipe(code) do |path|
      Process.exec(name, [*options, path, *args])
    end
  end

  def noop?
    code.empty?
  end

  def to_pretty(args : String = "")
    opts = Process.quote(options)
    interpreter_call = [name, opts].reject(&.empty?).join(" ")
    standard_input = "<(\ncat <<'EOF'\n#{code.strip}\nEOF\n)"

    [interpreter_call, standard_input, args].reject(&.empty?).join(" ")
  end

  private def parse(shebang : Array(String)) : Void
    @name = Process.find_executable(shebang[0].gsub(/^#!/, "")).as(String)

    @options = begin
      return [] of String unless shebang.size > 1

      shebang[1..]
    end

    Output.warn("`-S ...` is recommended when multiple parameters are given to `#!#{name}`") if needs_env_split?
  end

  # Included to avoid confusion over how shebangs truly work when using `env` as the interpreter.
  # See: https://man7.org/linux/man-pages/man1/env.1.html#OPTIONS
  private def needs_env_split?
    File.basename(name) == "env" && options.size > 1 && options[0] != "-S"
  end
end
