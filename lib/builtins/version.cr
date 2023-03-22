# frozen_string_literal: true

module Builtins
	class Version < Builtin
		def self.description
			"prints the version of ops that is running"
		end

		def run
			Output.out(::Version.version)

			true
		end
	end
end
