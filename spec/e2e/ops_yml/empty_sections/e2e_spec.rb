# frozen_string_literal: true

RSpec.describe "forwards" do
	let(:commands) do
		["help"]
	end

	include_context "ops e2e"

	it "succeeds" do
		expect(exit_codes).to all eq(0)
	end
end
