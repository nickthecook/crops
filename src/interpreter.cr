
struct Interpreter
  @@shell : String | Nil

  protected def self.shell : String
    {% if flag?(:darwin) %}
      @@shell ||= begin
        Process.find_executable(ENV.fetch("RUBYSHELL", "dash")).as(String)
      rescue TypeCastError
        Process.find_executable(ENV.fetch("RUBYSHELL", "sh")).as(String)
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

  getter :name, :options, :script

  @name : String = shell
  @options : Array(String) = [] of String
  @script : String = ""

  def initialize(content : String)
    match = /(\A#!.+\n|)([\S\s]*)\Z/.match(content).as(Regex::MatchData)
    shebang = Process.parse_arguments(match[1])
    shebang << self.class.shell unless shebang.any?

    self.name = shebang
    @script = match[2]
  end

  def exec(args : Array(String))
    exit 0 if noop?

    self.class.pipe(script) do |path|
      Process.exec(name, [*options, path, *args])
    end
  end

  def noop?
    script.empty?
  end

  def to_pretty(args : String = "")
    env_s = needs_env_split? ? "-S" : ""
    opts = Process.quote(options)
    shebang = [name, env_s, opts].reject(&.empty?).join(" ")
    content = "<(\ncat <<'EOF'\n#{script.strip}\nEOF\n)"

    [shebang, content, args].reject(&.empty?).join(" ")
  end

  private def name=(shebang : Array(String))
    @name = Process.find_executable(shebang[0].gsub(/^#!/, "")).as(String)

    @options = begin
      return [] of String unless shebang.size > 1

      shebang[1..]
    end.as(Array(String))
  end

  private def needs_env_split?
    File.basename(name) == "env" && options.size > 1
  end
end
