require "yaml_util"

class Action
  class ActionConfigError < RuntimeError; end
  getter :name, :aliases

  @aliases : Array(String)
  @config_errors : Array(String)?
  @command : String | Nil

  def initialize(name : String, config : Hash(String, YAML::Any), args : Array(String))
    @name = name
    @config = config
    @args = args
    @aliases = generate_aliases_list
  end

  private def generate_aliases_list
    if @config.keys.includes?("aliases")
      aliases = YamlUtil.array_of_strings(@config["aliases"])
    else
      aliases = [] of String
    end
    return aliases unless @config.keys.includes?("alias")

    if (alias_value = @config["alias"])
      alias_s = alias_value.as_s?
      aliases << alias_s if alias_s
    end

    aliases
  end

  def run
    if perform_shell_expansion?
      Output.debug("SHELL EXPANDING")
      Process.exec(command: to_s, shell: true)
    else
      Process.exec(executable, exec_args, shell: false)
    end
  end

  def to_s
    "#{command} #{@args.join(' ')}".strip
  end

  def alias : String | Nil
    return nil if @aliases.empty?

    @aliases.first
  end

  def executable : String
    l_command = command
    raise ActionConfigError.new("Command for action '#{@name}' is nil") if l_command.nil?

    l_command.split(" ").first
  end

  def exec_args : Array(String)
    l_command = command
    return [] of String if l_command.nil?

    l_command.split(" ")[1..] + @args
  end

  def command : String | Nil
    @command ||= begin
      l_config = @config
      if l_config.is_a?(String)
        l_config
      else
        @config["command"].to_s
      end
    end
  rescue KeyError
    nil
  end

  def description
    @config["description"]
  rescue KeyError
    nil
  end

  def skip_hooks?(name)
    skip_key = "skip_#{name}_hooks"
    @config.keys.includes?(skip_key) && @config[skip_key]
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
    return false unless @config.keys.includes?("load_secrets")

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

  private def not_in_envs : Array(String)
    return [] of String unless @config.keys.includes?("not_in_envs")

    YamlUtil.array_of_strings(@config["not_in_envs"])
  end

  private def in_envs : Array(String)
    return [] of String unless @config.keys.includes?("in_envs")

    YamlUtil.array_of_strings(@config["in_envs"])
  end

  private def skip_in_envs
    return [] of String unless @config.keys.includes?("skip_in_envs")

    YamlUtil.array_of_strings(@config["skip_in_envs"])
  end

  private def perform_shell_expansion? : Bool
    return true unless @config.keys.includes?("shell_expansion")

    @config["shell_expansion"].as_bool
  end
end
