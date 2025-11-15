RSpec.describe "encrypt builtin" do
	let(:commands) { ["encrypt"] }

	include_context "ops e2e"

	let(:commands) { [] }

	let!(:result) { ops("encrypt") }
	let(:exit_code) { result[EXIT_CODE_IDX] }
	let(:output) { result[OUTPUT_IDX] }

	it "fails with non-zero exit code" do
		expect(exit_code).to eq(1)
	end

	it "outputs error message" do
		expect(output).to match(/Encryption failed: stat config\/test\/secrets.ejson: no such file or directory/)
	end
end
