require "file_utils"
require "builtins/helpers/templates"

module Builtins
  class Init < Builtin
    CONFIG_FILES = ["ops.yml", "ops.yaml"]
    OPS_YML = CONFIG_FILES.first
    OPS_YML_TEMPLATE = File.join(template_dir, "%<template_name>s.template.yml")
    DEFAULT_TEMPLATE_NAME = "ops"

    def self.description
      "creates an ops.yml file from a template"
    end

    def run
      Output.debug("Template dir: #{template_dir}")
      if CONFIG_FILES.any? { |file| File.exists? file }
        Output.error("File '#{OPS_YML}' exists; not initializing.")

        return false
      end

      template_contents = template_for_name(template_name)
      if template_contents
        File.write(OPS_YML, template_contents)

        return true
      end

      Output.error("Could not find template for '#{template_name}'.")
      false
    end

    private def template_for_name(name)
      paths_for_name(name).each do |path|
        Output.debug("Looking for '#{path}'...")
        if File.exists?(path)
          Output.out("Using template '#{path}'...")
          return File.read(path)
        end
      end

      if templates.keys.includes?(name)
        Output.out("Using built-in template '#{name}'...")

        templates[name]
      end
    end

    private def paths_for_name(name)
      [
        File.join(template_dir, "#{name}.yml"),
        File.join(template_dir, "#{name}.yaml"),
        name,
      ]
    end

    private def templates
      Builtins::Helpers::Templates::TEMPLATES
    end

    private def template_name : String
      @args.size > 0 ? @args[0].to_s : "ops"
    end

    private def template_dir
      @template_dir ||= Options.get_s("init.template_dir") || "#{Path.home}/.ops_templates"
    end
  end
end
