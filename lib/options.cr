require "yaml"

class Options
  class OptionsError < Exception; end
  class OptionsTypeError < Exception; end

  @@options : Hash(String, YAML::Any) | Nil

  def self.get(path)
    env_var = ENV[env_var(path)]
    return YAML.parse(env_var) unless env_var.nil?

    return nil if @@options.nil?
    @@options.not_nil!.dig(*Tuple(String).from path.split("."))
  end

  def self.get_s(path) : String | Nil
    var_name = env_var(path)
    parsed_val = YAML.parse(var_name)

    return nil if parsed_val.nil?

    parsed_val.to_s
  end

  def self.set(options : Hash(String, YAML::Any) | Nil)
    @@options = options
  end

  private def self.env_var(path)
    "OPS__#{path.upcase.gsub(".", "__")}"
  end
end
