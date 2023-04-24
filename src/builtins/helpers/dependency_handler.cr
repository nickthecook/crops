require "dependencies"
require "dependencies/dependency"
require "dependencies/custom"
require "dependencies/gem"

module Builtins
	module Helpers
		class DependencyHandler
			@dependency_set : Hash(String, Array(String))

			def initialize(dependency_set)
				@dependency_set = dependency_set
			end

			def dependencies : Array(Dependencies::Dependency)
				@dependency_set.map do |type, definitions|
					dependencies_for(type, definitions)
				end.flatten
			end

			private def dependencies_for(type, definitions) Array(Dependencies::Dependency) | Nil
				dependencies = [] of Dependencies::Dependency
				dependency_class = Dependencies.class_for(type)

				if dependency_class
					definitions.each { |name| dependencies << dependency_class.new(name) }
				else
					Output.error("No way to handle dependencies of type '#{type}'; ignoring.")
				end

				dependencies
			end
		end
	end
end
