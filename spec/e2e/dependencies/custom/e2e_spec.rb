# frozen_string_literal: true

RSpec.describe "forwards" do
	include_context "ops e2e"

	before(:all) do
		# change to the directory containing this file
		Dir.chdir(__dir__)

		remove_untracked_files

		@output1, @output_file1, @exit_status1 = ops("up")
		@output2, @output_file2, @exit_status2 = ops("down")
	end

	it "succeeds" do
		expect(@exit_status1).to eq(0)
	end

	it "runs the String custom dependency" do
		expect(File.exist?("custom")).to be true
	end

	it "runs the 'up' portion of the split dependency" do
		expect(File.exist?("custom_up")).to be true
	end

	it "runs the 'down' portion of the split dependency" do
		expect(File.exist?("custom_down")).to be true
	end
end
