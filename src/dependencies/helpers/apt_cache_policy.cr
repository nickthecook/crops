module Dependencies
	module Helpers
		class AptCachePolicy
			INSTALLED_VERSION_REGEX = /  Installed: ([-+.a-z0-9]+)/

			getter :name

			@apt_cache_lines : Array(String) | Nil

			def initialize(name : String)
				@name = name
			end

			def installed_version
				version_from_policy_version_line(installed_version_line)
			end

			def installed?
				!!installed_version
			end

			private def installed_version_line
				apt_cache_lines.find { |line| line.match(/#{INSTALLED_VERSION_REGEX}/) }
			end

			private def version_from_policy_version_line(line)
				return nil if line.nil?

				# E.g.:
				#  Installed: 7.52.1-5+deb9u7
				match = line.match(/#{INSTALLED_VERSION_REGEX}/)

				match.nil? ? nil : match[1]
			end

			private def apt_cache_lines
				@apt_cache_lines ||= `apt-cache policy #{name}`.split("\n")
			end
		end
	end
end
