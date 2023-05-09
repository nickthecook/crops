# frozen_string_literal: true

RSpec.describe "up fail_on_error false" do
	include_context "ops e2e"

	let(:commands) { ["up"] }

	it "succeeds" do
		expect(exit_code).to eq(0)
	end
end
