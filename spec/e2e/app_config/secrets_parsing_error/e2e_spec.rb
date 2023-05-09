# frozen_string_literal: true

RSpec.describe "no actions" do
	let(:commands) { ["ls"] }

	include_context "ops e2e"

	it "fails" do
		expect(exit_code).to eq(66)
	end

	it "prints the name of the config file in the error message" do
		expect(output).to match(/config\/test\/secrets.json/)
	end
end
