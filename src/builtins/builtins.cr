require "builtins/builtin"
require "builtins/countdown"
require "builtins/down"
require "builtins/encrypt"
require "builtins/env"
require "builtins/envdiff"
require "builtins/exec"
require "builtins/help"
require "builtins/init"
require "builtins/up"
require "builtins/version"

module Builtins
  BUILTINS = {
    "countdown" => Countdown,
    "down" => Down,
    "encrypt" => Encrypt,
    "env" => Env,
    "envdiff" => Envdiff,
    "exec" => Exec,
    "help" => Help,
    "init" => Init,
    "up" => Up,
    "version" => Version
  }
  ALIASES = {
    "enc" => "encrypt",
    "h" => "help",
    "v" => "version"
  }

  def self.class_for(name : String) : Builtin.class | Nil
    if hyphenated?(name)
      name = name.lstrip("-")
    end

    name = ALIASES[name] if ALIASES.keys.includes?(name)
    return BUILTINS[name] if BUILTINS.keys.includes?(name)
  end

  def self.alias_for(name : String) : String | Nil
    ALIASES.key_for(name) if ALIASES.values.includes?(name)
  end

  def self.builtins : Array(String)
    BUILTINS.keys
  end

  private def self.hyphenated?(name : String) : Bool
    name.matches?(/^-[^-]$/) || name.matches?(/^--[^-].+$/)
  end
end
