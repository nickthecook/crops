require "dependencies/dependency"
require "dependencies/apk"
require "dependencies/apt"
require "dependencies/brew"
require "dependencies/cask"
require "dependencies/custom"
require "dependencies/gem"

module Dependencies
  DEPENDENCIES = {
    "custom" => Dependencies::Custom,
    "gem" => Dependencies::Gem,
    "apk" => Dependencies::Apk,
    "apt" => Dependencies::Apt,
    "brew" => Dependencies::Brew,
    "cask" => Dependencies::Cask
  }

  def self.class_for(name : String) : Dependency | Nil
    DEPENDENCIES[name] if DEPENDENCIES.keys.includes?(name)
  end
end
