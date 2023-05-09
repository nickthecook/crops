# frozen_string_literal: true

RSpec.describe "ops.yaml precedence" do
	let(:commands) { ["test"] }

	include_context "ops e2e"

	it "succeeds" do
		expect(exit_code).to eq(0)
	end

	it "outputs the string from ops.yaml" do
		expect(output).to match(/this is ops.yaml/)
	end
end
