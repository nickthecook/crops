require "forward"

class Forwards
  class ForwardsError < Exception; end

  def initialize(@ops_yml : OpsYml, @args = [] of String)
  end

  def get(name) : Forward | Nil
    Forward.new(forwards[name], @args) if forwards.keys.includes?(name)
  end

  def forwards : Hash(String, String)
    @ops_yml.forwards
  end
end
