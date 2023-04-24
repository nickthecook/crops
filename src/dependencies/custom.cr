require "dependencies/dependency"

module Dependencies
	class Custom < Dependency
		class CustomConfigError < Exception; end

    @name : String
    @config : Hash(String, String) | Nil
    @up_command : String?
    @down_command : String?

		def initialize(@definition : String | Hash(String, Hash(String, String)))
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
			return Tuple.new(@definition.to_s, nil) if @definition.is_a?(String)

			Output.debug("NOT A STRING")
      unless @definition.is_a?(Hash(String, Hash(String, String)))
        raise CustomConfigError.new("Each 'custom' depdendency must be a string or, e.g.: name: { up: 'up cmd', down: 'down cmd' }")
      end

			Hash.cast(@definition).first
		end
	end
end
