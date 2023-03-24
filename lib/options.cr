require "yaml"

class Options
  class OptionsError < Exception; end
  class OptionsTypeError < Exception; end

  @@options : Hash(String, YAML::Any) | Nil

  def self.get(path)
    env_var_path = env_var(path)
    env_var = ENV.includes?(env_var_path) ? ENV[env_var_path] : nil
    return YAML.parse(env_var) unless env_var.nil?

    l_options = @@options
    return nil if l_options.nil?
    dig(path.split("."))
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

  private def self.dig(keys : Array(String)) : YAML::Any | Nil
    keys = keys.dup

    value = @@options
    keys.each do |key|
      return nil if value.nil?
      value = value.as_h? if value.is_a?(YAML::Any)
      return nil unless value
      return nil unless value.includes?(key)
      value = value[key]
    end
  end
end
