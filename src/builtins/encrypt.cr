module Builtins
	class Encrypt < Builtin
		def self.description
			"encrypts secrets using ejson"
		end

		def run
			secrets_path = Secrets.app_config_path

			status, stdout, stderr = Command.capture3("ejson encrypt #{secrets_path}")

			if status != 0
			  Output.error("Error encrypting '#{secrets_path}': #{stderr}")
				return false
			end

			Output.out(stdout)
			true
		end
	end
end
