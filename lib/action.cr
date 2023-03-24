require "yaml_util"

class Action
  class ActionConfigError < RuntimeError; end
  getter :name

  @alias : String?
  @aliases : Array(String)
  @config_errors : Array(String)?

  def initialize(name : String, config : Hash(String, YAML::Any), args : Array(String))
    @name = name
    @config = config
    @args = args
    if config.includes?("aliases")
      @aliases = YamlUtil.array_of_strings(@config["aliases"])
    else
      @aliases = [] of String
    end
    @alias = @config["alias"].as_s? if @config.includes?("alias")
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
    alias_list = [] of String
    unless (l_alias = @alias).nil?
      alias_list << l_alias
    end
    alias_list = alias_list + @aliases

    return alias_list
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

  private def not_in_envs : Array(String)
    YamlUtil.array_of_strings(@config["not_in_envs"])
  end

  private def in_envs : Array(String)
    YamlUtil.array_of_strings(@config["in_envs"])
  end

  private def skip_in_envs
    YamlUtil.array_of_strings(@config["skip_in_envs"])
  end

  private def perform_shell_expansion? : Bool
    @config["shell_expansion"].nil? ? true : !!@config["shell_expansion"]
  end
end
