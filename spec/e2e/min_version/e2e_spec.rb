# frozen_string_literal: true

RSpec.describe "min_version checking" do
	include_context "ops e2e"

	before(:all) do
		Dir.chdir(__dir__)

		remove_untracked_files

		@output1, @output_file1, @exit_status1 = run_ops("../../../build/ops up")
		@output2, @output_file2, @exit_status2 = run_ops("../../../build/ops version")
	end

	it "fails with config error exit code" do
		expect(@exit_status1).to eq(67)
	end

	it "outputs an error about minimum version" do
		# TODO: update test when we hit version 99.99.99
		expect(@output1).to match(/ops.yml specifies minimum version of 99.99.99, but ops version is /)
	end

	it "runs 'version' successfully" do
		expect(@exit_status2).to eq(0)
	end
end
