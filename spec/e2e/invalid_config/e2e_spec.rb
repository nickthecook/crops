# frozen_string_literal: true

RSpec.describe "environment_loading" do
	let(:commands) { ["version"] }

	include_context "ops e2e"

	it "fails with code 66" do
		expect(exit_code).to eq(66)
	end

	it "outputs an error" do
		expect(output).to match(/Error parsing app config:/)
	end
end
