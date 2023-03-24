class Action
  class ActionConfigError < RuntimeError; end
  getter :name

  @alias : String?
  @aliases : Array(String)?
  @config_errors : Array(String)?

  def initialize(name : String, config : Hash(String, String | Array(String)) | String, args : Array(String))
    @name = name
    @config = config || {} of String => (String | Array(String))
    @args = args
    @aliases = @config["aliases"]
    @alias = @config["alias"]
  end

  def run
    Process.exec(command: to_s, shell: perform_shell_expansion?)
  end

  def to_s
    "#{command} #{@args.join(' ')}".strip
  end

  def alias : String
    aliases.first
  end

  def aliases : Array(String)
    ([@config["alias"]] << @config["aliases"]).compact
  end

  def command
    return @config if @config.is_a?(String)

    @config["command"]
  end

  def description
    @config["description"]
  end

  def skip_hooks?(name)
    @config["skip_#{name}_hooks"]
  end

  def config_valid?
    config_errors.empty?
  end

  def config_errors
    @config_errors ||= begin
      errors = [] of String

      errors << "No 'command' specified in 'action'." unless command

      errors
    end
  end

  def load_secrets?
    @config["load_secrets"].nil? ? false : @config["load_secrets"]
  end

  def execute_in_env?(env)
    !skip_in_envs.includes?(env)
  end

  def allowed_in_env?(env)
    return false if not_in_envs.includes?(env)

    return false if in_envs.any? && !in_envs.includes?(env)

    true
  end

  private def to_a
    command.split(" ").reject(&:nil?) | @args
  end

  private def not_in_envs 
    env_list = @config["not_in_envs"]
    raise ActionConfigError.new("'not_in_envs' must be list, but got '#{env_list}'.") if env_list.is_a?(String)

    env_list || [] of String
  end

  private def in_envs : Array(String)
    env_list = @config["in_envs"]
    raise ActionConfigError.new("'in_envs' must be list, but got '#{env_list}'.") if env_list.is_a?(String)

    env_list || [] of String
  end

  private def skip_in_envs
    env_list = @config["skip_in_envs"]
    raise ActionConfigError.new("'skip_in_envs' must be list, but got '#{env_list}'.") if env_list.is_a?(String)

    env_list || [] of String
  end

  private def perform_shell_expansion? : Bool
    @config["shell_expansion"].nil? ? true : !!@config["shell_expansion"]
  end
end
