# frozen_string_literal: true

RSpec.describe "help" do
	let(:commands) { ["help"] }

	include_context "ops e2e"

	it "succeeds" do
		expect(exit_code).to eq(0)
	end

	it "includes help for builtins other than 'help'" do
		expect(output).to match(/33mup\e/)
		expect(output).to match(/33mdown\e/)
		expect(output).to match(/33minit\e/)
		expect(output).to match(/33mexec\e/)
	end

	it "includes alias for help" do
		expect(output).to match(/help.* \[h\]/)
		expect(output).to match(/version.* \[v\]/)
	end
end
