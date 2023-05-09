# frozen_string_literal: true

RSpec.describe "no actions" do
	let(:commands) { ["up"] }

	include_context "ops e2e"

	it "succeeds" do
		expect(exit_code).to eq(0)
	end
end
