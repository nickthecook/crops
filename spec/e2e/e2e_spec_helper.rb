# frozen_string_literal: true

require 'open3'

OUTPUT_IDX = 0
OUTPUT_FILE_IDX = 1
EXIT_CODE_IDX = 2

shared_context "ops e2e" do
	ENV["OPS_RUNNING"] = nil
	ENV["OPS_DEBUG_OUTPUT"] = "true"

	let(:ops_env_vars) { {} }

	def remove_untracked_files
		untracked_files = `git ls-files --others | grep -v '.rb$' | grep -v '$.yml'`.split("\n")
		untracked_files.each { |file| `rm -f #{file}` }
	end

	def run_ops(cmd, output_file = "ops.out")
		output, status = Open3.capture2e(ops_env_vars, cmd)

		File.write(output_file, output)

		[output, output_file, status.exitstatus]
	end
end
