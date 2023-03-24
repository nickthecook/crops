require "yaml"

require "options"
require "output"
require "ops_yml"
require "version"
require "runner"

class Ops
  INVALID_SYNTAX_EXIT_CODE = 64
  UNKNOWN_ACTION_EXIT_CODE = 65
  ERROR_LOADING_APP_CONFIG_EXIT_CODE = 66
  MIN_VERSION_NOT_MET_EXIT_CODE = 67
  ACTION_CONFIG_ERROR_EXIT_CODE = 68
  BUILTIN_SYNTAX_ERROR_EXIT_CODE = 69
  ACTION_NOT_ALLOWED_IN_ENV_EXIT_CODE = 70
  ERROR_LOADING_OPS_YML_EXIT_CODE = 71

  RECOMMEND_HELP_TEXT = "Run 'ops help' for a list of builtins and actions."

  @action_name : String
  @args : Array(String)
  @config : Hash(String, YAML::Any) | Nil
  @runner : Runner | Nil

  def self.project_name : String
    Dir.current.split("/").last
  end

  def initialize(argv, config_file = nil)
    @action_name = argv[0]
    @args = argv[1..-1]
    @config_file = config_file || "ops.yml"

    Options.set(ops_yml.options || {} of String => YAML::Any)
    check_for_config_file
  end

  # rubocop:disable Metrics/MethodLength
  # better to have all the rescues in one place
  def run
    # "return" is here to allow specs to stub "exit" without executing everything after it
    return exit(INVALID_SYNTAX_EXIT_CODE) unless syntax_valid?
    return exit(MIN_VERSION_NOT_MET_EXIT_CODE) unless min_version_met?

    runner.run
  rescue e : Runner::UnknownActionError
    Output.error(e.to_s)
    exit(UNKNOWN_ACTION_EXIT_CODE)
  rescue e : Runner::ActionConfigError
    Output.error("Error(s) running action '#{@action_name}': #{e}")
    exit(ACTION_CONFIG_ERROR_EXIT_CODE)
  rescue e : Builtins::Builtin::ArgumentError
    Output.error("Error running builtin '#{@action_name}': #{e}")
    exit(BUILTIN_SYNTAX_ERROR_EXIT_CODE)
  rescue e : AppConfig::ParsingError
    Output.error("Error parsing app config: #{e}")
    exit(ERROR_LOADING_APP_CONFIG_EXIT_CODE)
  rescue e : Runner::NotAllowedInEnvError
    Output.error("Error running action #{@action_name}: #{e}")
    exit(ACTION_NOT_ALLOWED_IN_ENV_EXIT_CODE)
  rescue e : OpsYml::OpsYmlError
    Output.error("Error loading #{@config_file}: #{e}")
    exit(ERROR_LOADING_OPS_YML_EXIT_CODE)
  rescue e : YamlUtil::YamlError
    Output.error("Error loading #{@config_file}: #{e}")
    exit(ERROR_LOADING_OPS_YML_EXIT_CODE)
  end
  # rubocop:enable Metrics/MethodLength

  private def syntax_valid?
    return true unless @action_name.nil?

    Output.error("Usage: ops <action>")
    Output.out(RECOMMEND_HELP_TEXT)
    false
  end

  private def min_version_met?
    return true unless min_version

    if Version.min_version_met?(min_version)
      true
    else
      Output.error("ops.yml specifies minimum version of #{min_version}, but ops version is #{Version.version}")
      false
    end
  end

  def min_version
    ops_yml.config["min_version"]
  rescue KeyError
    nil
  end

  private def runner
    @runner ||= Runner.new(@action_name, @args, ops_yml)
  end

  private def ops_yml : OpsYml
    @ops_yml ||= OpsYml.new(@config_file)
  end

  private def check_for_config_file
    Output.warn("File '#{@config_file}' does not exist.") unless @action_name == "init"
  end
end
