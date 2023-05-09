# frozen_string_literal: true

RSpec.describe "forwards" do
	let(:commands) { %w[expansion no-expansion] }

	include_context "ops e2e"

	it "succeeds" do
		expect(exit_codes).to all eq(0)
	end

	it "performs shell expansion by default" do
		expect(outputs[0]).to match(/\nhello\n/)
	end

	it "does not perform shell expansion when disabled in config" do
		expect(outputs[1]).to match(/\n"hello"\n/)
	end
end
