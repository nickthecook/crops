module Builtins
	class Env < Builtin
		def self.description
			"prints the current environment, e.g. 'dev', 'production', 'staging', etc."
		end

		def run
			Output.print(environment)

			true
		end

		def environment
			ENV["environment"]
		end
	end
end
