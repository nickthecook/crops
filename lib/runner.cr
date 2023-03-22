require "forwards"
require "app_config"
require "action_list"
require "secrets"
require "builtins"

module Builtins
end

class Runner
  class UnknownActionError < Exception; end
  class ActionConfigError < Exception; end
  class NotAllowedInEnvError < Exception; end

  @action_name : String
  @args : Array(String)
  @ops_yml : OpsYml
  @forward : Forward | Nil
  @action_list : ActionList | Nil
  @builtin : Builtins::Builtin | Nil

  def initialize(action_name, args, ops_yml)
    @action_name = action_name
    @args = args
    @ops_yml = ops_yml
  end

  def run
    return forward.not_nil!.run if forward

    do_before_all

    return builtin.run if builtin

    raise UnknownActionError, "Unknown action: #{@action_name}" unless action
    raise ActionConfigError, action.config_errors.join("; ") unless action.config_valid?

    do_before_action

    run_action
  end

  def suggestions
    @suggestions ||= ActionSuggester.new(action_list.names + action_list.aliases + builtin_names).check(@action_name)
  end

  private def do_before_all
    AppConfig.load
    Secrets.load if action.not_nil!.load_secrets?
    environment.set_variables
  end

  private def do_before_action
    return if ENV["OPS_RUNNING"] || action.skip_hooks?("before")

    # this prevents before hooks from running in ops executed by ops
    ENV["OPS_RUNNING"] = "1"
    hook_handler.do_hooks("before")
  end

  private def hook_handler
    @hook_handler ||= HookHandler.new(@ops_yml.config)
  end

  private def builtin
    @builtin ||= Builtins.class_for(name: @action_name).new(@args, @ops_yml)
  end

  private def builtin_names
    Builtins.constants.select { |c| Builtins.const_get(c).is_a? Class }.map(&:downcase)
  end

  private def forward
    @forward ||= Forwards.new(@ops_yml, @args).get(@action_name)
  end

  private def run_action
    unless action.allowed_in_env?(Environment.environment)
      raise NotAllowedInEnvError, "Action not allowed in #{Environment.environment} environment."
    end

    unless action.execute_in_env?(Environment.environment)
      Output.warn("Skipping action '#{action.name}' in environment #{Environment.environment}.")
      return true
    end

    Output.notice("Running '#{action}' in environment '#{ENV["environment"]}'...")
    action.run
  end

  private def action
    return action_list.get(@action_name) if action_list.get(@action_name)
    return action_list.get_by_alias(@action_name) if action_list.get_by_alias(@action_name)
  end

  private def action_list
    @action_list ||= begin
      Output.warn("'ops.yml' has no 'actions' defined.") if @ops_yml.config.any? && @ops_yml.config["actions"].nil?

      ActionList.new(@ops_yml.actions, @args)
    end
  end

  private def environment
    @environment ||= Environment.new(@ops_yml.env_hash, @ops_yml.absolute_path)
  end
end
