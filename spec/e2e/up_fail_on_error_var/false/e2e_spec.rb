# frozen_string_literal: true

RSpec.describe "$OPS__UP__FAIL_ON_ERROR false" do
	include_context "ops e2e"

	let(:commands) { ["up"] }

	it "succeeds" do
		expect(exit_code).to eq(0)
	end
end
