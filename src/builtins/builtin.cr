module Builtins
  class Builtin
    class ArgumentError < Exception; end

    getter :args, :ops_yml

    def initialize(args : Array(String), ops_yml : OpsYml)
      @args = args
      @ops_yml = ops_yml
    end

    def self.description
      "no description"
    end

    def run
      raise NotImplementedError.new("Builtins must implement 'run'.")
    end
  end
end
