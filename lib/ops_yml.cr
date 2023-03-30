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

    config
  end

  def config : Hash(String, YAML::Any)
    @config ||= if config_file_exists?
      contents = YamlUtil.hash_with_string_keys(parsed_config_contents)
    else
      {} of String => YAML::Any
    end
  end

  def options : YAML::Any | Nil
    return nil if (l_config = config).nil?

    l_config["options"]
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
      if config.keys.includes?("dependencies")
        dependencies_from_config = YamlUtil.hash_with_string_keys(config["dependencies"])
        dependencies = {} of String => Array(String)

        dependencies_from_config.each do |key, value|
          dependencies[key] = YamlUtil.array_of_strings(value)
        end
      end

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
    return {} of String => YAML::Any if (l_config = config).nil?

    YamlUtil.hash_with_string_keys(l_config[name])
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
