# frozen_string_literal: true

require "colorize"

module Builtins
	class Help < Builtin
		NAME_WIDTH = 40

		def self.description
			"displays available builtins, actions, and forwards"
		end

		def run : Bool
			list("Builtins", builtins) if builtins.any?
			list("Forwards", forwards) if forwards.any?
			list("Actions", actions) if actions.any?

			true
		end

		private def list(name, items)
			Output.out("#{name}:")
			Output.out("  #{items.join("\n  ")}")
			Output.out("")
		end

		private def forwards
			Forwards.new(@ops_yml).forwards.map do |name, dir|
				"#{name.colorize(:yellow)}-#{NAME_WIDTH}s #{dir.to_s}"
			end
		end

		private def builtins
			Builtins::BUILTINS.keys
		end

		private def actions
			return [] of String unless @ops_yml.actions

			@ops_yml.actions.map do |name, action_config|
				name = "#{name.colorize(:yellow)} #{alias_string_for(action_config)}"
				desc = action_config["description"] || action_config["command"]

				"#{name}-#{NAME_WIDTH}s #{desc}"
			end.sort
		end

		private def alias_string_for(action_config)
			return "[#{action_config["alias"]}]" if action_config["alias"]

			""
		end
	end
end
