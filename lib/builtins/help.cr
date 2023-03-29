# frozen_string_literal: true

require "colorize"

module Builtins
	class Help < Builtin
		NAME_WIDTH = 30

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

			action_list = ActionList.new(@ops_yml.actions, [] of String)
			action_list.names.map do |name|
				action = action_list.get(name)
				next if action.nil?

				desc = action.description || action.command

				"%-#{NAME_WIDTH}s %s %s" % [name.colorize(:yellow), action.aliases.join(","), desc]
			end
		end

		private def alias_string_for(action_config : YAML::Any) : String
			return "" if action_config.as_s?

			return "[#{action_config["alias"]}]" if action_config["alias"]

			""
		end
	end
end
