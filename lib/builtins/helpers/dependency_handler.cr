require "dependencies"
require "dependencies/dependency"
require "dependencies/custom"

module Builtins
	module Helpers
		class DependencyHandler
			@dependency_set : Hash(String, Array(String))

			def initialize(dependency_set)
				@dependency_set = dependency_set
			end

			def dependencies : Array(Dependencies::Dependency)
				return [] of Dependencies::Dependency unless @dependency_set

				@dependency_set.map do |type, definitions|
					dependencies_for(type, definitions)
				end.flatten.compact
			end

			private def dependencies_for(type, definitions) Array(Dependencies::Dependency) | Nil
				dependency_class = type.capitalize

				dependencies = [] of Dependencies::Dependency

				case dependency_class
				when "custom"
					definitions.each { |name| dependencies << Dependencies::Custom.new(name) }
				else
					Output.error("No way to handle dependencies of type '#{type}'; ignoring.")
				end

				dependencies
			end
		end
	end
end
