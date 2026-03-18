require "json"
require "command"

require "app_config"

class Secrets < AppConfig
  @ejson_contents : String | Nil

  def self.default_filename
    config_path_for(Environment.environment)
  end

  def self.config_path_for(env)
    File.exists?(ejson_path_for(env)) ? ejson_path_for(env) : json_path_for(env)
  end

  def self.app_config_path
    expand_path(Options.get("secrets.path") || default_filename)
  end

  private def self.ejson_path_for(env)
    "config/#{env}/secrets.ejson"
  end

  private def self.json_path_for(env)
    "config/#{env}/secrets.json"
  end

  def initialize(filename = "")
    @filename = filename.empty? ? Secrets.default_filename : actual_filename_for(filename)
  end

  private def actual_filename_for(filename)
    File.exists?(filename) ? filename : filename.sub(".ejson", ".json")
  end

  private def file_contents
    @file_contents ||= @filename.match(/\.ejson$/) ? ejson_contents : super
  end

  private def ejson_contents
    @ejson_contents ||= begin
      status, stdout, stderr = Command.capture3("ejson decrypt #{@filename}")

      # ejson _should_ exit with non-zero if there was an error
      raise ParsingError.new("#{@filename}: 'ejson' exited with #{status}: #{stderr}") unless status.zero?

      stdout
    end
  end
end
