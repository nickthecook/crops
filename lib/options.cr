require "yaml"

class Options
  class OptionsError < Exception; end

  @@options : Hash(String, YAML::Any) | Nil

  def self.get(path)
    env_var = ENV[env_var(path)]
    return YAML.parse(env_var) unless env_var.nil?

    return nil if @@options.nil?
    @@options.not_nil!.dig(*Tuple(String).from path.split("."))
  end

  def self.set(options : Hash(String, YAML::Any) | Nil)
    @@options = options
  end

  private def self.env_var(path)
    "OPS__#{path.upcase.gsub(".", "__")}"
  end
end
