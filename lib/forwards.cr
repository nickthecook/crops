require "forward"

class Forwards
  class ForwardsError < Exception; end

  def initialize(@ops_yml : OpsYml, @args = [] of String)
    # @ops_yml = ops_yml
    # @args = args
  end

  def get(name) : Forward | Nil
    Forward.new(forwards[name], @args) if forwards[name]
  end

  def forwards : Hash(String, String)
    @ops_yml.forwards
  end
end
