require "dependencies/dependency"
require "dependencies/custom"
require "dependencies/gem"

module Dependencies
  DEPENDENCIES = {
    "custom" => Dependencies::Custom,
    "gem" => Dependencies::Gem
  }

  def self.class_for(name : String) : Dependency | Nil
    DEPENDENCIES[name] if DEPENDENCIES.keys.includes?(name)
  end
end
