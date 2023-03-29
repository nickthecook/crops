require "dependencies/dependency"
require "dependencies/apk"
require "dependencies/apt"
require "dependencies/brew"
require "dependencies/custom"
require "dependencies/gem"

module Dependencies
  DEPENDENCIES = {
    "custom" => Dependencies::Custom,
    "gem" => Dependencies::Gem,
    "apk" => Dependencies::Apk,
    "apt" => Dependencies::Apt,
    "brew" => Dependencies::Brew
  }

  def self.class_for(name : String) : Dependency | Nil
    DEPENDENCIES[name] if DEPENDENCIES.keys.includes?(name)
  end
end
