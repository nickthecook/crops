# frozen_string_literal: true

module Builtins
	class Envdiff < Builtin
		def self.description
			"compares keys present in config and secrets between different environments"
		end

		@source_only_keys : Array(String) | Nil
		@dest_only_keys : Array(String) | Nil
		@source_keys : Array(String) | Nil
		@dest_keys : Array(String) | Nil
		@ignored_keys : Array(String) | Nil

		def run
			check_args

			if source_only_keys.empty? && dest_only_keys.empty?
				Output.out("Environments '#{source_env}' and '#{dest_env}' define the same #{source_keys.size} key(s).")
				return
			end

			output_key_summary(source_only_keys, source_env, dest_env) if source_only_keys.any?
			output_key_summary(dest_only_keys, dest_env, source_env) if dest_only_keys.any?

			true
		end

		private def output_key_summary(keys, in_env, not_in_env)
			Output.warn("Environment '#{in_env}' defines keys that '#{not_in_env}' does not:\n")
			keys.each do |key|
				Output.warn("   - #{key}")
			end
			Output.out("")
		end

		private def source_only_keys
			@source_only_keys ||= source_keys - dest_keys
		end

		private def dest_only_keys
			@dest_only_keys ||= dest_keys - source_keys
		end

		private def source_keys
			@source_keys ||= keys_for(source_env)
		end

		private def dest_keys
			@dest_keys ||= keys_for(dest_env)
		end

		private def keys_for(env)
			tagged_config_keys_for(env) + tagged_secrets_keys_for(env)
		end

		private def tagged_config_keys_for(env)
			config_keys_for(env).map do |key|
				"[CONFIG] #{key}"
			end
		end

		private def tagged_secrets_keys_for(env)
			secrets_keys_for(env).map do |key|
				"[SECRET] #{key}"
			end
		end

		private def config_keys_for(env)
			(config_for(env).environment.keys) - ignored_keys
		end

		private def secrets_keys_for(env)
			(secrets_for(env).environment.keys) - ignored_keys
		end

		private def config_for(env) : AppConfig
			AppConfig.new(config_path_for(env))
		end

		private def secrets_for(env) : AppConfig
			AppConfig.new(secrets_path_for(env))
		end

		private def check_args
			raise Builtin::ArgumentError.new("Usage: ops envdiff <env_one> <env_two>") unless args.size == 2

			check_environment(source_env)
			check_environment(dest_env)
		end

		private def source_env
			args[0]
		end

		private def dest_env
			args[1]
		end

		private def check_environment(name)
			warn_missing_file(config_path_for(name)) unless config_file_exists?(name)
			warn_missing_file(secrets_path_for(name)) unless secrets_file_exists?(name)
		end

		private def warn_missing_file(path)
			Output.warn("File '#{path}' does not exist.")
		end

		private def config_file_exists?(env)
			File.exists?(config_path_for(env))
		end

		private def secrets_file_exists?(env)
			File.exists?(secrets_path_for(env))
		end

		private def config_path_for(env)
			AppConfig.config_path_for(env)
		end

		private def secrets_path_for(env)
			Secrets.config_path_for(env)
		end

		private def ignored_keys : Array(String)
			@ignored_keys ||= begin
				option = Options.get("envdiff.ignored_keys")
				option = YamlUtil.array_of_strings(option) if option

				if option.nil?
					[] of String
				else
					raise Options::OptionsError.new("Option 'envdiff.ignored_keys' must be an array of strings; got #{option.class.name}.") unless option.is_a?(Array(String))

					option
				end
			end
		end
	end
end
