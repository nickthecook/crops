require "builtins/builtin"
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
    "down" => Down,
    "env" => Env,
    "envdiff" => Envdiff,
    "exec" => Exec,
    "help" => Help,
    "init" => Init,
    "up" => Up,
    "version" => Version,
  }

  def self.class_for(name : String) : Builtin | Nil
    BUILTINS[builtin_class_name_for(name)]
  end

  private def self.builtin_class_name_for(name : String) : String
    name.capitalize
  end
end
