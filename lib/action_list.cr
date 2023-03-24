require "action"

class ActionList
  class UnknownActionError < Exception; end
  class ActionFormatError < Exception; end

  def initialize(actions_list : Hash(String, YAML::Any), args : Array(String))
    @actions_list = actions_list
    @args = args
    @actions = {} of String => Action
    @aliases = {} of String => Action

    process_action_list
  end

  def get(name)
    @actions[name] if names.includes?(name)
  end

  def get_by_alias(name)
    @aliases[name] if aliases.includes?(name)
  end

  def names
    @actions.keys
  end

  def aliases
    @aliases.keys
  end

  private def actions_list
    @actions_list ||= {} of String => Hash(String, YAML::Any)
  end

  private def process_action_list
    actions_list.each do |name, config|
      if config.is_a?(YAML::Any)
        hash = {} of String => YAML::Any
        hash["command"] = config
        config = hash
      end

      action = Action.new(name, config, @args)

      @actions[name] = action
      action.aliases.each do |aliaz|
        check_duplicate_alias(name, aliaz)
        @aliases[aliaz] = action
      end
    end
  end

  private def check_duplicate_alias(name, aliaz)
    return if @aliases[aliaz].nil?

    Output.warn("Duplicate alias '#{aliaz}' detected in action '#{name}'.")
  end
end
