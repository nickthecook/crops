# frozen_string_literal: true

require 'open3'

OUTPUT_IDX = 0
OUTPUT_FILE_IDX = 1
EXIT_CODE_IDX = 2

shared_context "ops e2e" do
	ENV["OPS_RUNNING"] = nil
	ENV["OPS_DEBUG_OUTPUT"] = "true"

	# this is a method so specs can call `ops` inside a `before` block;
	# however, if a spec needs to override this, it should use `let(:ops_env_vars)` so nothing leaks
	def ops_env_vars
		{}
	end

	def remove_untracked_files
		untracked_files = `git ls-files --others | grep -v '.rb$' | grep -v '.yml$' | grep -v '.json$'`.split("\n")
		untracked_files.each { |file| `rm -f #{file}` }
	end

	def ops(cmd, output_file = "ops.out")
		path = "../build/ops"
		5.times do
			break path if File.executable?(path)

			path = "../#{path}"
		end

		output, status = Open3.capture2e(ops_env_vars, "#{path} #{cmd}")

		File.write(output_file, output)

		[output, output_file, status.exitstatus]
	end

	let!(:results) do
		commands.map do |command|
			ops(command)
		end
	end
	let(:exit_codes) { results.map { |result| result[EXIT_CODE_IDX] } }
	let(:outputs) { results.map { |result| result[OUTPUT_IDX] } }
	let(:exit_code) { results.first[EXIT_CODE_IDX] }
	let(:output) { results.first[OUTPUT_IDX] }
end
