# frozen_string_literal: true

require 'json'

RSpec.describe "encrypt builtin" do
	let(:commands) { ["encrypt"] }

	include_context "ops e2e"

	context "with default secrets path" do
		it "succeeds" do
			expect(exit_code).to eq(0)
		end

		it "outputs ejson encryption message" do
			expect(output).to match(/Wrote \d+ bytes to/)
		end
	end

	context "when using enc alias" do
		let(:commands) { ["enc"] }

		it "succeeds" do
			expect(exit_code).to eq(0)
		end

		it "outputs ejson encryption message" do
			expect(output).to match(/Wrote \d+ bytes to/)
		end
	end

	context "when no secrets file is configured" do
		let(:commands) { [] }

		before do
			# Remove the secrets file and directory
			`rm -rf config`

			# Create ops.yml without secrets configuration
			File.write("ops.yml", <<~YAML)
				min_version: 2.0.0
				actions:
				  test:
				    command: echo "test action"
			YAML
		end

		let!(:result) { ops("encrypt") }
		let(:exit_code) { result[EXIT_CODE_IDX] }
		let(:output) { result[OUTPUT_IDX] }

		it "fails with non-zero exit code" do
			expect(exit_code).to eq(1)
		end

		it "outputs error message" do
			expect(output).to match(/No secrets file configured/)
		end
	end
end
