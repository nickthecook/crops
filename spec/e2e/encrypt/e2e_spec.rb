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
end
