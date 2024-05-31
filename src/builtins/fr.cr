module Builtins
  class Fr < Builtin
    DEFAULT_FR_INTERVAL = 1

    def self.description
      "runs the given action until it succeeds"
    end

    def run
      loop do
        break if Ops.new(args).run == 0

        sleep(Options.get("fr.interval") || DEFAULT_FR_INTERVAL)
      end
    end
  end
end
