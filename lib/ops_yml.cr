require "yaml"

class OpsYml
  class OpsYmlError < Exception; end

  @config : Hash(String, YAML::Any) | Nil
  @options : Hash(String, YAML::Any) | Nil
  @env_hash : Hash(String, YAML::Any) | Nil
  @forwards : Hash(String, String) | Nil

  def initialize(config_file : String)
    @config_file = config_file
  end

  def config : Hash(String, YAML::Any)
    @config ||= if config_file_exists?
      contents = hash_with_string_keys(parsed_config_contents)
    else
      {} of String => YAML::Any
    end
  end

  def options : Hash(String, YAML::Any)
    @options ||= config_section("options")
  end

  def actions : Hash(String, YAML::Any)
    @actions ||= begin
      actions = config["actions"]

      raise OpsYmlError.new("'actions' must be a Hash with String keys.") unless actions.is_a?(Hash(String, YAML::Any))

      actions || {} of String => YAML::Any
    end
  end

  def forwards : Hash(String, String)
    @forwards ||= begin
      forwards = config["forwards"]
      return {} of String => String unless forwards

      raise OpsYmlError.new("'forwards' must be a Hash with String keys and String values.") unless forwards.is_a?(Hash(String, String))

      forwards
    end
  end

  def dependencies : Hash(String, Array(String))
    @dependencies ||= begin
    dependencies = config["dependencies"]

    raise OpsYmlError.new("'dependencies' must be a hash with keys of type string and values of type array of string.") unless dependencies.is_a?(Hash(String, Array(String)))

    dependencies || {} of String => Array(String)
    end
  end

  def env_hash
    @env_hash ||= begin
      env_hash = config.dig("options", "environment")

      raise OpsYmlError.new("'options.environment' must be a hash with string keys.") unless env_hash.is_a?(Hash(String, YAML::Any))

      env_hash
    end
  end

  def absolute_path
    File.expand_path(@config_file)
  end

  private def config_section(name : String) : Hash(String, YAML::Any)
    return {} of String => YAML::Any if (config = @config).nil?

    hash_with_string_keys(config[name])
  rescue KeyError
    {} of String => YAML::Any
  end

  private def hash_with_string_keys(any : YAML::Any) : Hash(String, YAML::Any)
    hash = any.as_h?
    raise OpsYmlError.new("Expected hash, got #{any}") unless hash

    keys_to_string(hash)
  end

  private def keys_to_string(hash : Hash(YAML::Any, YAML::Any)) : Hash(String, YAML::Any)
    hash.transform_keys do |k|
      k = k.as_s?
      raise OpsYmlError.new("Hash keys must be String.") unless k

      k
    end
  end

  private def parsed_config_contents : YAML::Any
    YAML.parse(File.open(@config_file))
  rescue e : Exception
    raise OpsYmlError.new(e.to_s)
  end

  private def config_file_exists?
    File.exists?(@config_file)
  end
end
