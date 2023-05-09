# frozen_string_literal: true

RSpec.describe "up fail_on_error true" do
	let(:commands) { ["up"] }

	include_context "ops e2e"

	it "fails" do
		expect(exit_code).to eq(1)
	end
end
