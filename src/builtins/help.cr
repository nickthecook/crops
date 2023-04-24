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
				"%-#{NAME_WIDTH}s %s" % [name.colorize(:yellow), dir.to_s]
			end
		end

		private def builtins
			Builtins::BUILTINS.keys.map do |builtin|
				builtin_class = Builtins.class_for(builtin)
				next unless builtin_class

				"%-#{NAME_WIDTH}s %s" % [builtin.colorize(:yellow), builtin_class.description]
			end
		end

		private def actions
			return [] of String unless @ops_yml.actions

			action_list = ActionList.new(@ops_yml.actions, [] of String)
			action_list.names.map do |name|
				action = action_list.get(name)
				next if action.nil?

				desc = action.description || action.command
				name_and_aliases = if action.aliases.any?
					"#{name.colorize(:yellow)} [#{action.aliases.join(",")}]"
				else
					name.colorize(:yellow)
				end

				"%-#{NAME_WIDTH}s %s" % [name_and_aliases, desc]
			end
		end

		private def alias_string_for(action_config : YAML::Any) : String
			return "" if action_config.as_s?

			return "[#{action_config["alias"]}]" if action_config["alias"]

			""
		end
	end
end
