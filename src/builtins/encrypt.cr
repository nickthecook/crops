module Builtins
	class Encrypt < Builtin
		def self.description
			"encrypts secrets using ejson"
		end

		def run
			secrets_path = Secrets.app_config_path

			if secrets_path.nil? || secrets_path.empty?
				Output.error("No secrets file configured")
				return false
			end

			Process.exec("ejson e #{secrets_path}", shell: true)
		end
	end
end
