# frozen_string_literal: true

RSpec.describe "$OPS__UP__FAIL_ON_ERROR true" do
	let(:commands) { ["up"] }

	include_context "ops e2e"

	it "fails" do
		expect(exit_code).to eq(1)
	end
end
