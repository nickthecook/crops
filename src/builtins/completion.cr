require "builtins/helpers/completion_scripts"

module Builtins
  class Completion < Builtin
		def self.description
			"prints the tab completion script for the given shell"
		end

    def run
      first = @args[0]?
      rest = @args[1..-1]? || [] of String

      # "--" is used for completions, if first arg isn't "--", it is the shell name
      unless first == "--"
        script = completion_scripts[first]?

        unless script
          STDERR.puts "No completion script available for shell: #{first}"
          return false
        end

        puts script
        return true
      end

      parsed = parse_args(rest)
      curr = parsed["curr"]? || ""
      prev = parsed["prev"]? || ""

      prev_tokens = prev.split

      active_ops_yml = resolve_ops_yml(prev_tokens) || return false
      actions_and_aliases = get_actions_and_aliases(active_ops_yml)

      # Check if past all ops subcommands
      # Early return without outputting to stdout tells the shell to provide default file completions
      prev_tokens.each do |token|
        if actions_and_aliases.includes?(token) || BUILTINS.has_key?(token)
          return true
        end
      end

      suggestions = [] of String

      BUILTINS.each_key do |c|
        suggestions << c
      end

      active_ops_yml.forwards.each_key do |c|
        suggestions << c
      end

      active_ops_yml.actions.each_key do |c|
        suggestions << c
      end

      suggestions
        .select { |c| curr.empty? || c.starts_with?(curr) }
        .sort
        .each { |c| puts c }

      true
    end

    private def parse_args(args : Array(String))
      result = {} of String => String

      args.each do |arg|
        if index = arg.index('=')
          result[arg[0...index]] = arg[(index + 1)..-1]
        end
      end

      result
    end

    private def resolve_ops_yml(prev_tokens : Array(String))
      current_yml = @ops_yml

      # Skip command name (ops)
      prev_tokens.skip(1).each do |token|
        forward_dir = current_yml.forwards[token]?
        unless forward_dir
          token_is_action = get_actions_and_aliases(current_yml).includes?(token)
          token_is_builtin = BUILTINS.has_key?(token)

          return token_is_action || token_is_builtin ? current_yml : nil
        end

        root_dir = File.dirname(current_yml.absolute_path)
        absolute_forward_dir = File.expand_path(forward_dir, root_dir)

        ops_file = resolve_ops_file(absolute_forward_dir)

        unless ops_file
          return current_yml
        end

        current_yml = OpsYml.new(ops_file)
      end

      current_yml
    end

    private def resolve_ops_file(dir : String)
      yml_path = File.join(dir, "ops.yml")
      yaml_path = File.join(dir, "ops.yaml")

      if File.exists?(yml_path)
        return yml_path
      elsif File.exists?(yaml_path)
        return yaml_path
      end

      nil
    end

    private def get_actions_and_aliases(ops_yml)
      action_list = ActionList.new(ops_yml.actions, [] of String)

      action_list.names() + action_list.aliases()
    end

    private def completion_scripts
      Builtins::Helpers::CompletionScripts::COMPLETION_SCRIPTS
    end
  end
end
