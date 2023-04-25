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
			execute(up_command) if up_command
		end

		def unmeet : Bool
			downcmd = down_command
			return true if downcmd.nil?

			execute(downcmd)
		end

		private def up_command
			@up_command ||= begin
        if @config
          @definition.is_a?(Hash) ? @config.not_nil!.dig("up") : name
        else
          @name
        end
      end
		end

		private def down_command
			@down_command ||= begin
        if @config
          @config.not_nil!.dig("down") || nil
        else
          nil
        end
      end
		end

		private def parse_definition : Tuple(String, Hash(String, String) | Nil)
			l_def = @definition
			return Tuple.new(l_def.to_s, nil) if l_def.is_a?(String)

			hss = l_def.transform_values do |value|
				value.to_s
			end

			Tuple.new(l_def.to_s, hss)
		end
	end
end
