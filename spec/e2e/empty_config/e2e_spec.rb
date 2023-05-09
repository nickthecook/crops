# frozen_string_literal: true

RSpec.describe "environment_loading" do
	let(:commands) { ["exec 'echo hello'"] }

	include_context "ops e2e"

	it "succeeds" do
		expect(exit_code).to eq(0)
	end

	it "outputs a warning for empty config" do
		require 'pry-byebug'
		expect(output).to match(/Config file 'config\/test\/config.json' exists but is empty./)
	end

	it "outputs a warning for empty secrets" do
		expect(output).to match(/Config file 'config\/test\/secrets.json' exists but is empty./)
	end
end
