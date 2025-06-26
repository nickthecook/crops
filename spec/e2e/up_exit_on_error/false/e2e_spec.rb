# frozen_string_literal: true

RSpec.describe "up exit_on_error false" do
	include_context "ops e2e"

	let(:commands) { ["up"] }

	it "executes the dependency after the failure" do
		expect(output).to match(/yep/)
	end
end
