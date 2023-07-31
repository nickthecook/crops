# frozen_string_literal: true

require "colorize"

module Builtins
	class Help < Builtin
		NAME_WIDTH = 30

		def self.description
			"displays available builtins, actions, and forwards"
		end

		def self.usage(render : Symbol | Nil = nil) : String
			header = "Usage:"
			content = "ops [-f <FILENAME>] [-q] [<FORWARD>] <ACTION> [...]"
			template = "%s %s"

			case render
			when :error
				template = template.colorize(:red).to_s
			else
				header = header.colorize(:white)
			end

			template % [header, content]
		end

		def run : Bool
			Output.out("")
			Output.out("#{self.class.usage}\n\n")
			
			list("Builtins", builtins) if builtins.any?
			list("Forwards", forwards) if forwards.any?
			list("Actions", actions) if actions.any?

			true
		end

		private def list(name : String, items : Hash(String, String))
			renders = items.map do |name, desc|
				"  %-#{name_width}s  %s" % [name, description_string(desc)]
			end

			Output.out("#{name}:".colorize(:white).to_s)
			Output.out("#{renders.join("\n")}")
			Output.out("")
		end

		private def name_width : Int32
			@name_width ||= Math.max(name_longest.size, NAME_WIDTH).as(Int32)
		end

		private def name_longest : String
			@name_longest ||= names.max_by { |name| name.size }.as(String)
		end

		private def names : Array(String)
			@names ||= [*builtins.keys, *forwards.keys, *actions.keys].as(Array(String))
		end

		private def builtins
			@builtins ||= Builtins.builtins.map do |builtin|
				builtin_class = Builtins.class_for(builtin)
				next unless builtin_class

				{ builtin_with_alias(builtin).to_s, builtin_class.description.to_s }
			end.compact.to_h.as(Hash(String, String))
		end

		private def forwards
			@forwards ||= Forwards.new(@ops_yml).forwards.to_h do |name, dir|
				{ name.colorize(:red).to_s, dir.to_s }
			end.as(Hash(String, String))
		end

		private def builtin_with_alias(name) : String
			l_alias = Builtins.alias_for(name)
			return "%s [%s]" % [name.colorize(:yellow), l_alias] if l_alias

			name.colorize(:yellow).to_s
		end

		private def actions
			@actions ||= begin
				return {} of String => String unless @ops_yml.actions

				action_list = ActionList.new(@ops_yml.actions, [] of String)
				action_list.names.map do |name|
					action = action_list.get(name)
					next if action.nil?
	
					desc = (action.description || action.command).to_s
					name_and_aliases = name_string(name, action.aliases)
	
					{ name_and_aliases, desc }
				end.compact.to_h
			end.as(Hash(String, String))
		end

		private def name_string(name : String, aliases : Array(String)) : String
			name = name.colorize(:cyan).to_s
			return "#{name} [#{aliases.join(",")}]" if aliases.any?

			name
		end

		private def description_string(content : String) : String
			content.split("\n").join("\n  %-#{name_width}s  " % ["".colorize(:yellow)])
		end
	end
end
