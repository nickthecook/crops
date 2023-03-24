require "yaml"
require "yaml_util"

class OpsYml
  class OpsYmlError < Exception; end

  @config : Hash(String, YAML::Any) | Nil
  @options : Hash(String, YAML::Any) | Nil
  @actions : Hash(String, YAML::Any) | Nil
  @env_hash : Hash(String, YAML::Any) | Nil
  @forwards : Hash(String, String) | Nil

  def initialize(config_file : String)
    @config_file = config_file
  end

  def config : Hash(String, YAML::Any)
    @config ||= if config_file_exists?
      contents = YamlUtil.hash_with_string_keys(parsed_config_contents)
    else
      {} of String => YAML::Any
    end
  end

  def options : Hash(String, YAML::Any)
    @options ||= config_section("options")
  end

  def actions : Hash(String, YAML::Any)
    @actions ||= config_section("actions")
  end

  def forwards : Hash(String, String)
    @forwards ||= begin
      forwards_section = config_section("forwards")

      forwards_section.transform_values do |value|
        value = value.as_s?

        raise OpsYmlError.new("'forwards' must be Hash of String => String.") unless value

        value
      end
    end
  end

  def dependencies : Hash(String, Array(String))
    @dependencies ||= begin
    dependencies = config["dependencies"]

    raise OpsYmlError.new("'dependencies' must be a hash with keys of type string and values of type array of string.") unless dependencies.is_a?(Hash(String, Array(String)))

    dependencies || {} of String => Array(String)
    end
  end

  def env_hash : Hash(String, YAML::Any)
    @env_hash ||= begin
      env_hash = config.dig?("options", "environment")
      return {} of String => YAML::Any if env_hash.nil?

      YamlUtil.hash_with_string_keys(env_hash)
    end
  end

  def absolute_path
    File.expand_path(@config_file)
  end

  private def config_section(name : String) : Hash(String, YAML::Any)
    return {} of String => YAML::Any if (config = @config).nil?

    YamlUtil.hash_with_string_keys(config[name])
  rescue KeyError
    {} of String => YAML::Any
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
