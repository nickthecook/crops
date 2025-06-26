# frozen_string_literal: true

RSpec.describe "$OPS__UP__EXIT_ON_ERROR false" do
	include_context "ops e2e"

	let(:commands) { ["up"] }

	it "executes the dependency after the failure" do
		expect(output).to match(/yep/)
	end
end
