require "file_utils"

module Builtins
	class Init < Builtin
		OPS_YML = "ops.yml"
		TEMPLATE_DIR = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "etc"))
		OPS_YML_TEMPLATE = File.join(TEMPLATE_DIR, "%<template_name>s.template.yml")
		DEFAULT_TEMPLATE_NAME = "ops"

		def self.description
			"creates an ops.yml file from a template"
		end

		def run
			if File.exists?(OPS_YML)
				Output.error("File '#{OPS_YML} exists; not initializing.")

				return false
			end

			Output.out("Creating '#{OPS_YML} from template...")
			FileUtils.cp(template_path, OPS_YML)

			true
		end

		private def template_name
			@args[0]
		end

		private def template_path
			return template_name if template_name && File.exists?(template_name)

			builtin_template_path
		end

		private def builtin_template_path
			"#{template_name}.template.yml"
		end

		private def template_name_list
			matches = name.match(/^([^.]*).template.yml/)
			return [] of String unless matches

			@template_name_list ||= Dir.entries(TEMPLATE_DIR).map do |name|
				matches.captures.first
			end.compact
		end

		private def template_not_found_message
			<<-MESSAGE
				Template '#{template_path}' does not exist.
				\nValid template names are:
				   - #{template_name_list.join("\n   - ")}\n
			MESSAGE
		end
	end
end
