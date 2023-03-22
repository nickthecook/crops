class Environment
  def self.environment
    return "dev" if ENV["environment"].nil? || ENV["environment"].empty?

    ENV["environment"]
  end

  def initialize(env_hash : Hash(String, YAML::Any), config_path : String)
    @env_hash = env_hash
    @config_path = config_path
  end

  def set_variables
    set_ops_variables
    set_environment_aliases
    set_configured_variables
  end

  private def set_ops_variables
    ENV["OPS_YML_DIR"] = File.dirname(@config_path)
    ENV["OPS_VERSION"] = Version.version.to_s
    ENV["OPS_SECRETS_FILE"] = Secrets.app_config_path
    ENV["OPS_CONFIG_FILE"] = AppConfig.app_config_path
  end

  private def set_environment_aliases
    environment_aliases.each do |alias_name|
      ENV[alias_name] = Environment.environment
    end
  end

  private def environment_aliases
    aliases = Options.get("environment_aliases")

    raise Options::OptionsError.new("'options.environment_aliases' must be an Array of Strings.") unless aliases.is_a?(Array(String))

    aliases || ["environment"]
  end

  private def set_configured_variables
    @env_hash.each do |key, value|
      ENV[key] = `echo #{value}`.chomp
    end
  end
end
