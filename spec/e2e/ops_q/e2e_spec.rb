# frozen_string_literal: true

RSpec.describe "forwards" do
	let(:commands) do
		[
			"jenkins",
			"-q jenkins",
			"--quiet jenkins",
		]
	end

	include_context "ops e2e"

	it "succeeds" do
		expect(exit_codes).to all eq(0)
	end

	it "outputs the command to stderr" do
		expect(outputs[0]).to match(/echo "Hello, Leeeeeroy"/)
	end

	it "does not output the command to stderr when the `-q` flag is present" do
		expect(outputs[1]).not_to match(/echo "Hello, Leeeeeroy"/)
	end

	it "does not output the command to stderr when the `--quiet` flag is present" do
		expect(outputs[2]).not_to match(/echo "Hello, Leeeeeroy"/)
	end
end
