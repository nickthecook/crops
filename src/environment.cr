require "yaml_util"

class Environment
  def self.environment
    return "dev" unless ENV.keys.includes?("environment")
    return "dev" if ENV["environment"].nil? || ENV["environment"].empty?

    ENV["environment"]
  end

  def initialize(env_hash : Hash(String, YAML::Any), config_path : String)
    @env_hash = env_hash
    @config_path = config_path
  end

  def set_variables
    set_ops_variables
    set_environment_file_variables
    set_environment_aliases
    set_configured_variables
  end

  private def set_ops_variables
    ENV["OPS_YML_DIR"] = File.dirname(@config_path)
    ENV["OPS_VERSION"] = Version.version.to_s
    ENV["OPS_SECRETS_FILE"] = Secrets.app_config_path
    ENV["OPS_CONFIG_FILE"] = AppConfig.app_config_path
  end

  private def parse_environment_file_line(line : String)
    # Skip empty lines and comments
    stripped = line.strip
    return if stripped.empty? || stripped.starts_with?("#")

    # Parse KEY=VALUE format
    parts = stripped.split("=", 2)
    return if parts.size != 2

    key = parts[0].strip
    value = parts[1].strip

    # Remove surrounding quotes if present
    if (value.starts_with?('"') && value.ends_with?('"')) ||
       (value.starts_with?('\'') && value.ends_with?('\''))
      value = value[1...-1]
    end

    ENV[key] = value
  end

  private def set_environment_file_variables
    env_file = Options.get("environment_file")
    return unless env_file

    expanded_path = File.expand_path(env_file.to_s)
    return unless File.exists?(expanded_path)
    
    File.each_line(expanded_path) do |line|
      parse_environment_file_line(line)
    end
  end

  private def set_environment_aliases
    environment_aliases.each do |alias_name|
      ENV[alias_name] = Environment.environment
    end
  end

  private def environment_aliases
    aliases = Options.get("environment_aliases")

    return ["environment"] if aliases.nil?

    YamlUtil.array_of_strings(aliases)
  end

  private def set_configured_variables
    @env_hash.each do |key, value|
      ENV[key] = `echo #{value}`.chomp
    end
  end
end
