require "dependencies/dependency"

module Dependencies
	class Custom < Dependency

		@name : String
		@config : Hash(String, String) | Nil
		@up_command : String?
		@down_command : String?

		def initialize(@definition : String | Hash(String, YAML::Any))
			super
			@name, @config = parse_definition
		end

		def met?
			false
		end

		def always_act?
			true
		end

		def meet
			l_up_command = up_command
			execute(l_up_command) if l_up_command
		end
		
		def unmeet : Bool
			downcmd = down_command
			return true if downcmd.nil?
			
			execute(downcmd)
		end

		private def up_command
			@up_command ||= begin
				l_config = @config

				if l_config
					l_config.keys.includes?("up") ? l_config.dig("up") : nil
				else
					@name
				end
			end
		end

		private def down_command
			@down_command ||= begin
				l_config = @config

				if l_config
					l_config.keys.includes?("down") ? l_config.dig("down") : nil
				else
					nil
				end
			end
		end

		private def parse_definition : Tuple(String, Hash(String, String) | Nil)
			l_def = @definition
			return Tuple.new(l_def.to_s, nil) if l_def.is_a?(String)

			hss = YamlUtil.hash_with_string_keys(l_def.first_value).transform_values { |v| v.to_s }

			Tuple.new(l_def.first_key, hss)
		end
	end
end
