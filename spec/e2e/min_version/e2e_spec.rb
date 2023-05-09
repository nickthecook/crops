# frozen_string_literal: true

RSpec.describe "min_version checking" do
	let(:commands) { %w[up version] }

	include_context "ops e2e"

	it "fails with config error exit code" do
		expect(exit_codes[0]).to eq(67)
	end

	it "outputs an error about minimum version" do
		# TODO: update test when we hit version 99.99.99
		expect(outputs[0]).to match(/ops.yml specifies minimum version of 99.99.99, but ops version is /)
	end

	it "runs 'version' successfully" do
		expect(exit_codes[1]).to eq(0)
	end
end
