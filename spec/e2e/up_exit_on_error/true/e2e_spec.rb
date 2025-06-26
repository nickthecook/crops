# frozen_string_literal: true

RSpec.describe "up exit_on_error true" do
	include_context "ops e2e"

	let(:commands) { ["up"] }

	it "executes the dependency after the failure" do
		expect(output).not_to match(/nope/)
	end
end
