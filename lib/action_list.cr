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
    @actions[name]
  end

  def get_by_alias(name)
    @aliases[name]
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
      unless config.is_a?(Hash(String, String | Array(String))) || config.is_a?(String)
        raise ActionFormatError.new("Action values must be Hash or String.")
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
