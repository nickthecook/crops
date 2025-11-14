RSpec.describe "encrypt builtin" do
	let(:commands) { ["encrypt"] }

	include_context "ops e2e"

	let(:commands) { [] }

	let!(:result) { ops("encrypt") }
	let(:exit_code) { result[EXIT_CODE_IDX] }
	let(:output) { result[OUTPUT_IDX] }

	it "succeeds" do
		expect(exit_code).to eq(0)
	end

	it "encrypts the custom file" do
		expect(output).to match(/Wrote \d+ bytes to/)
	end
end
