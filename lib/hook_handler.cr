# frozen_string_literal: true

class HookHandler
	class HookConfigError < RuntimeError; end
	class HookExecError < RuntimeError; end

	def initialize(@hooks_config : Hash(String, YAML::Any))
	end

	def do_hooks(name)
		raise HookConfigError.new("'hooks.#{name}' must be a list") unless hooks(name).is_a?(Array)

		execute_hooks(name)
	end

	private def hooks(name) : Array(String)
		return [] of String unless @hooks_config
		return [] of String unless @hooks_config.keys.includes?(name)

		hooks_list = @hooks_config[name].as_a
		return hooks_list.map { |hook| hook.to_s }
	end

	private def execute_hooks(name)
		hooks(name).each do |hook|
			Output.notice("Running #{name} hook: #{hook}")
			executor = execute_hook(hook)

			next if executor.success?

			raise HookExecError.new("#{name} hook '#{hook}' failed with exit code #{executor.exit_code}:\n#{executor.output}")
		end
	end

	private def execute_hook(cmd : String) : Executor
		executor = Executor.new(cmd)
		executor.execute

		executor
	end
end
