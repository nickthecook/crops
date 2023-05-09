# frozen_string_literal: true

RSpec.describe "forwards" do
	let(:commands) { %w[up down] }

	include_context "ops e2e"

	it "succeeds" do
		expect(exit_codes).to all eq(0)
	end

	it "runs the String custom dependency" do
		expect(File.exist?("custom")).to be true
	end

	it "runs the 'up' portion of the split dependency" do
		expect(File.exist?("custom_up")).to be true
	end

	it "runs the 'down' portion of the split dependency" do
		expect(File.exist?("custom_down")).to be true
	end
end
