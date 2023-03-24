class YamlUtil
  class YamlError < RuntimeError; end

  def self.hash_with_string_keys(any : YAML::Any) : Hash(String, YAML::Any)
    hash = any.as_h?
    raise YamlError.new("Expected hash, got #{any}") unless hash

    keys_to_string(hash)
  end

  def self.keys_to_string(hash : Hash(YAML::Any, YAML::Any)) : Hash(String, YAML::Any)
    hash.transform_keys do |k|
      k = k.as_s?
      raise YamlError.new("Hash keys must be String.") unless k

      k
    end
  end

  def self.array_of_strings(any : YAML::Any) : Array(String)
    array = any.as_a?
    raise YamlError.new("Expected list, got #{any.class} '#{any}'.") if array.nil?

    array = array.map do |item|
      item = item.as_s?

      raise YamlError.new("Expected string, got #{item.class} '#{item}'.") if item.nil?

      item
    end
  end
end
