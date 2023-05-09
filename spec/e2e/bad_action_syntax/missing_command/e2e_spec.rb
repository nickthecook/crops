# frozen_string_literal: true

RSpec.describe "hooks" do
	include_context "ops e2e"

	let(:commands) { ["hello"] }

	it "succeeds" do
		expect(exit_code).to eq(68)
	end

	it "outputs an error" do
		expect(output).to match(/No 'command' specified in 'action'./)
	end
end
