require "yaml"

class Options
  class OptionsError < Exception; end
  class OptionsTypeError < Exception; end

  @@options : YAML::Any | Nil

  def self.get(path) : YAML::Any | Nil
    env_var_path = env_var(path)
    env_var = ENV.keys.includes?(env_var_path) ? ENV[env_var_path] : nil
    return YAML.parse(env_var) unless env_var.nil?

    l_options = @@options
    return nil if l_options.nil?
    self.digmfer(l_options, path.split("."))
  end

  def self.get_s(path) : String | Nil
    value = get(path)

    value.as_s? if value
  end

  def self.get_b(path) : Bool | Nil
    value = get(path)
    return false if value == false || value.nil?

    true
  end
  
  def self.set(options : YAML::Any | Nil)
    @@options = options
  end

  private def self.digmfer(obj : YAML::Any, keys : Array(String)) : YAML::Any | Nil
    return obj if keys.empty?

    hash = obj.as_h?
    return nil if hash.nil?
    return nil unless hash.keys.includes?(keys.first)

    digmfer(hash[keys.first], keys[1..])
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
