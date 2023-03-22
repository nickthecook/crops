# frozen_string_literal: true

require "builtins/common/up_down"

module Builtins
	class Down < Common::UpDown
		def handle_dependency(dependency)
			dependency.unmeet
		end
	end
end
