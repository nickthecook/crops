require "json"

require "environment"
require "yaml_util"

class AppConfig
  class ParsingError < Exception; end
  class AppConfigError < Exception; end

  @file_contents : String | Nil
  @environment : Hash(String, YAML::Any) | Nil

  def self.load
    new(app_config_path).load
  end

  def self.default_filename
    config_path_for(Environment.environment)
  end

  def self.config_path_for(env)
    "config/#{env}/config.json"
  end

  def self.app_config_path
    expand_path(Options.get("config.path") || default_filename)
  end

  private def self.expand_path(path)
    `echo #{path}`.chomp
  end

  def initialize(@filename = "")
    # @filename = filename
  end

  def environment : Hash(String, YAML::Any)
    @environment ||= begin
    return {} of String => YAML::Any unless config.includes?("environment")
    environment = YamlUtil.hash_with_string_keys(config["environment"])

      raise AppConfigError.new("'environment' must be a hash with string keys.") unless environment.is_a?(Hash(String, YAML::Any))

      environment
    end
  end

  def load
    environment.each do |key, value|
      ENV[key] = value.is_a?(Hash) || value.is_a?(Array) ? value.to_json : value.to_s
    end
  end

  private def config : Hash(String, YAML::Any)
    @config ||= if file_contents == ""
      {} of String => YAML::Any
    elsif file_contents
      parsed_contents = YAML.parse(file_contents.not_nil!)
      YamlUtil.hash_with_string_keys(parsed_contents)
    else
      {} of String => YAML::Any
    end
  rescue e : YAML::ParseException
    raise ParsingError.new("#{@filename}: #{e}")
  end

  private def file_contents
    @file_contents ||= begin
      File.read(@filename)
    rescue e : File::NotFoundError
      nil
    end
  end
end
