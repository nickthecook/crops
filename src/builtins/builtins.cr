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
  }

  def self.class_for(name : String) : Builtin.class | Nil
    BUILTINS[name] if BUILTINS.keys.includes?(name)
  end
end
