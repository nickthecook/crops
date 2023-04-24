require "executor"

module Dependencies
  class Dependency
    DESCRIPTION_TYPE_WIDTH = 8

    @executor : Executor | Nil

    getter :name

    def initialize(name : String)
      @name = name
    end

    def met?
      raise NotImplementedError.new("subclasses must implement")
    end

    def meet
      raise NotImplementedError.new("subclasses must implement")
    end

    def unmeet
      raise NotImplementedError.new("subclasses must implement")
    end

    # should_meet? can be used to implement dependencies that should only be met on some platforms,
    # e.g. brew on Macs and apt on Linux
    # it can be used to base a decision on anything else that can be read from the environment at
    # runtime
    def should_meet?
      true
    end

    # if true, this type of resource must always have `meet` and `unmeet` called;
    # useful for resources that can't easily be checked to see if they're met
    def always_act?
      false
    end

    def type
      self.class.name.split("::").last
    end

    def success? : Bool
      executor = @executor
      executor.nil? ? true : executor.success?
    end

    def output : String
      executor = @executor
      return "" if executor.nil?

      executor.output
    end

    def exit_code : Integer | Nil
      return nil unless @executor.exit_code

      @executor.exit_code
    end

    private def execute(cmd : String) : Bool
      executor = Executor.new(cmd)
      @executor = executor
      executor.execute

      executor.success?
    end
  end
end
