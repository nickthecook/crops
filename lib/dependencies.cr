require "dependencies/dependency"
require "dependencies/apk"
require "dependencies/apt"
require "dependencies/brew"
require "dependencies/cask"
require "dependencies/custom"
require "dependencies/dir"
require "dependencies/docker"
require "dependencies/gem"
require "dependencies/pip"
require "dependencies/snap"
require "dependencies/sshkey"

module Dependencies
  DEPENDENCIES = {
    "custom" => Dependencies::Custom,
    "gem" => Dependencies::Gem,
    "apk" => Dependencies::Apk,
    "apt" => Dependencies::Apt,
    "brew" => Dependencies::Brew,
    "cask" => Dependencies::Cask,
    "dir" => Dependencies::Dir,
    "docker" => Dependencies::Docker,
    "pip" => Dependencies::Pip,
    "snap" => Dependencies::Snap,
    "sshkey" => Dependencies::Sshkey
  }

  def self.class_for(name : String) : Dependency | Nil
    DEPENDENCIES[name] if DEPENDENCIES.keys.includes?(name)
  end
end
