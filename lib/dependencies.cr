require "dependencies/dependency"
require "dependencies/custom"
require "dependencies/gem"
require "dependencies/apk"

module Dependencies
  DEPENDENCIES = {
    "custom" => Dependencies::Custom,
    "gem" => Dependencies::Gem,
    "apk" => Dependencies::Apk
  }

  def self.class_for(name : String) : Dependency | Nil
    DEPENDENCIES[name] if DEPENDENCIES.keys.includes?(name)
  end
end
