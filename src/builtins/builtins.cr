require "builtins/builtin"
require "builtins/countdown"
require "builtins/down"
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
    "env" => Env,
    "envdiff" => Envdiff,
    "exec" => Exec,
    "help" => Help,
    "init" => Init,
    "up" => Up,
    "version" => Version,
    "h" => Help,
    "v" => Version
  }

  def self.class_for(name : String) : Builtin.class | Nil
    return BUILTINS[name] if BUILTINS.keys.includes?(name)

    if hyphenated?(name)
      name = name.lstrip("-")

      return BUILTINS[name] if BUILTINS.keys.includes?(name)
    end
  end

  private def self.hyphenated?(name : String) : Bool
    name.matches?(/^-[^-]$/) || name.matches?(/^--[^-].+$/)
  end
end
