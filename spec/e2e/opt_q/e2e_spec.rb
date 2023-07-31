# frozen_string_literal: true

RSpec.describe "forwards" do
	let(:commands) do
		[
			"jenkins",
			"-q jenkins",
			"--quiet jenkins",
			"-q nested",
			"nested_q",
			"nested_env",
			"inverse_env",
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

	context "when commands are nested," do
		it "outputs the nested command (no -q), but not the parent command (w/ -q), to stderr" do
			expect(outputs[3]).not_to match(/ops -q nested/)
			expect(outputs[3]).to match(/echo "Hello, Leeeeeroy"/)
		end

		it "outputs the parent command (w/ -q), but not the nested command (no -q), to stderr" do
			expect(outputs[4]).to match(/ops -q jenkins/)
			expect(outputs[4]).not_to match(/echo "Hello, Leeeeeroy"/)
		end
	end

	context "when `$OPS_QUIET_OUTPUT" do
		it "== 'true'`, globally suppresses commands from stderr, needless of `-q`" do
			expect(outputs[5]).not_to match(/ops -q jenkins/)
			expect(outputs[5]).not_to match(/echo "Hello, Leeeeeroy"/)
		end

		it "== 'false'`, globally outputs commands to stderr, despite `-q`" do
			expect(outputs[6]).to match(/ops -q jenkins/)
			expect(outputs[6]).to match(/echo "Hello, Leeeeeroy"/)
		end
	end
end
