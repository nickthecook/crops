# frozen_string_literal: true

RSpec.describe "bad ejson contents" do
	let(:commands) { ["up"] }

	include_context "ops e2e"

	it "fails with config error exit code" do
		expect(exit_code).to eq(66)
	end

	it "outputs an error about decrypting ejson" do
		expect(output).to match(/Error parsing app config:/)
	end
end
