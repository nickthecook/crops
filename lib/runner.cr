require "forwards"
require "app_config"
require "action_list"
require "secrets"
require "builtins"
require "hook_handler"

module Builtins
end

class Runner
  class UnknownActionError < RuntimeError; end
  class UnknownForwardError < RuntimeError; end
  class ActionConfigError < RuntimeError; end
  class NotAllowedInEnvError < RuntimeError; end

  @action_name : String
  @args : Array(String)
  @ops_yml : OpsYml
  @action_list : ActionList | Nil
  @builtin : Builtins::Builtin | Nil
  @action : Action | Nil

  def initialize(action_name, args, ops_yml)
    @action_name = action_name
    @args = args
    @ops_yml = ops_yml
    @action = action
  end

  def run
    l_forward = forward
    return l_forward.run if l_forward

    do_before_all

    l_builtin = builtin
    return l_builtin.run if l_builtin

    l_action = @action
    raise UnknownActionError.new("Unknown action: #{@action_name}") if l_action.nil?
    raise ActionConfigError.new(l_action.config_errors.join("; ")) unless l_action.config_valid?

    do_before_action

    run_action
  end

  private def do_before_all
    AppConfig.load
    l_action = action
    Secrets.load if l_action && l_action.load_secrets?
    environment.set_variables
  end

  private def do_before_action
    return if ENV["OPS_RUNNING"] || @action.not_nil!.skip_hooks?("before")

    # this prevents before hooks from running in ops executed by ops
    ENV["OPS_RUNNING"] = "1"
    hook_handler.do_hooks("before")
  end

  private def hook_handler
    HookHandler.new(@ops_yml.config)
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
    unless @action.not_nil!.allowed_in_env?(Environment.environment)
      raise NotAllowedInEnvError.new("Action not allowed in #{Environment.environment} environment.")
    end

    unless @action.not_nil!.execute_in_env?(Environment.environment)
      Output.warn("Skipping action '#{@action.not_nil!.name}' in environment #{Environment.environment}.")
      return true
    end

    Output.notice("Running '#{@action}' in environment '#{ENV["environment"]}'...")
    action.not_nil!.run
  end

  private def action : Action | Nil
    action_by_name = action_list.get(@action_name)
    return action_by_name if action_by_name

    action_by_alias = action_list.get_by_alias(@action_name)
    return action_by_alias
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
