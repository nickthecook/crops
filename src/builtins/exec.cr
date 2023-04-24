module Builtins
	class Exec < Builtin
		def self.description
			"executes the given command in the `ops` environment, i.e. with environment variables set"
		end

		def run
			Secrets.load if Options.get("exec.load_secrets")

			if args.any?
				Process.exec(args.join(" "), shell: true)
			else
				Output.error("Usage: ops exec '<command>'")

				false
			end
		end
	end
end
