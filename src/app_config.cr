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
    # Check for YAML files first, then fall back to JSON for backward compatibility
    ["config.yml", "config.yaml", "config.json"].each do |filename|
      path = "config/#{env}/#{filename}"
      return path if File.exists?(expand_path(path))
    end

    # Default to config.json if no file exists (maintains existing behavior)
    "config/#{env}/config.json"
  end

  def self.app_config_path
    expand_path(Options.get("config.path") || default_filename)
  end

  private def self.expand_path(path)
    # Replace $environment with actual environment value before shell expansion
    # This is needed because AppConfig.load runs before environment.set_variables
    path_str = path.to_s
    path_with_env = path_str.gsub("$environment", Environment.environment)
    `echo #{path_with_env}`.chomp
  end

  def initialize(@filename : String)
  end

  def environment : Hash(String, YAML::Any)
    @environment ||= begin
      return {} of String => YAML::Any unless config.keys.includes?("environment")
      environment = YamlUtil.hash_with_string_keys(config["environment"])

      environment
    end
  end

  def load
    environment.each do |key, value|
      if (hash_value = value.as_h?)
        value = value.to_json
      elsif (array_value = value.as_a?)
        value = value.to_json
      else
        value = value.to_s
      end

      ENV[key] = value
    end
  end

  private def config : Hash(String, YAML::Any)
    @config ||= if file_contents == ""
			Output.warn("Config file '#{@filename}' exists but is empty.")
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
      Output.debug("Loading config file '#{@filename}'...")
      File.read(@filename)
    rescue e : File::NotFoundError
      nil
    end
  end
end
