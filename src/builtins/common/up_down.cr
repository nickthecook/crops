require "dependencies/dependency"
require "builtins/helpers/dependency_handler"

module Builtins
	module Common
		class FailedDependencyError < RuntimeError; end

		class UpDown < Builtin
			def self.description
				"attempts to meet dependencies listed in ops.yml"
			end

			@deps_to_meet : Array(Dependencies::Dependency) | Nil

			def run
				meet_dependencies

				return true unless fail_on_error?

				deps_to_meet.all? { |dep| dep.success? }
			end

			private def meet_dependencies
				deps_to_meet.each do |dependency|
					Output.status("[#{dependency.type}] #{dependency.name}")

					result = meet_dependency(dependency)

					if !result && exit_on_error?
						raise FailedDependencyError.new("Failed to meet #{dependency.type} dependency '#{dependency.name}'")
					end
				end
			end

			private def meet_dependency(dependency) : Bool
				handle_dependency(dependency) if !dependency.met? || dependency.always_act?

				if dependency.success?
					Output.okay

					true
				else
					Output.failed
					Output.error("Error meeting #{dependency.type} dependency '#{dependency.name}':")
					Output.out(dependency.output)

					false
				end
			end

			private def deps_to_meet
				@deps_to_meet ||= dependency_handler.dependencies.select { |dep| dep.should_meet? }
			end

			private def dependency_handler
				Helpers::DependencyHandler.new(dependencies)
			end

			private def dependencies
				return @ops_yml.dependencies if @args.empty?

				@ops_yml.dependencies.select { |dep, _names| @args.includes?(dep) }
			end

			private def fail_on_error?
				Options.get("up.fail_on_error") || false
			end

			private def exit_on_error?
				Options.get("up.exit_on_error") || false
			end

			private def handle_dependency(dependency : Dependencies::Dependency)
				raise NotImplementedError.new("subclasses must implement")
			end
		end
	end
end
