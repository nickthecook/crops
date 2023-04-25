class YamlUtil
  class YamlError < RuntimeError; end

  def self.hash_with_string_keys(any : YAML::Any) : Hash(String, YAML::Any)
    hash = any.as_h?
    raise YamlError.new("Expected hash, got #{any.class.name}: #{any}") unless hash

    keys_to_string(hash)
  end

  def self.keys_to_string(hash : Hash(YAML::Any, YAML::Any)) : Hash(String, YAML::Any)
    hash.transform_keys do |k|
      k = k.as_s?
      raise YamlError.new("Hash keys must be String.") unless k

      k
    end
  end

  def self.array(any : YAML::Any) : Array(YAML::Any)
    array = any.as_a?
    raise YamlError.new("Expected list, got #{any.class} '#{any}'.") if array.nil?

    array
  end

  def self.array_of_strings(any : YAML::Any) : Array(String)
    array = any.as_a?
    raise YamlError.new("Expected list, got #{any.class} '#{any}'.") if array.nil?

    array = array.map do |item|
      # put coercion for any type => String here
      item = item.as_s? || item.as_bool?.to_s

      raise YamlError.new("Expected string, got #{item.class} '#{item}'.") if item.nil?

      item
    end
  end
end
