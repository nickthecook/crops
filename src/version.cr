require "semantic_version"

class Version
  def self.name_and_version
    "crops-#{version}.rc20"
  end

  def self.version : String
    "2.0.0"
  end

  def self.min_version_met?(min_version) : Bool
    return false unless min_version
    return false unless (l_min_version = min_version.as_s?)

    SemanticVersion.parse(l_min_version) <= SemanticVersion.parse(version)
  end
end
