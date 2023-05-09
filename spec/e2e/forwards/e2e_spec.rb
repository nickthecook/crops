# frozen_string_literal: true

RSpec.describe "forwards" do
	include_context "ops e2e"

	let(:commands) { ["app action_one", "app action_two", "app config_val", "app secret_val", "app echo_var", "app echo_top_var"]}

	it "succeeds" do
		expect(exit_codes).to all eq(0)
	end

	it "runs action_one in 'app/'" do
		expect(outputs[0]).to match(/action one/)
	end

	it "runs action_two in 'app/'" do
		expect(outputs[1]).to match(/action two/)
	end

	it "sets the config from the app dir" do
		expect(outputs[2]).to match(/app value one/)
	end

	it "does not set the config from the top-level dir" do
		expect(outputs[2]).not_to match(/top value one/)
	end

	it "sets the secret from the app dir" do
		expect(outputs[3]).to match(/app secret one/)
	end

	it "does not set the secret from the top-level dir" do
		expect(outputs[3]).not_to match(/top secret one/)
	end

	it "sets env vars from app options" do
		expect(outputs[4]).to match(/app-level value/)
	end

	it "does not set env vars from top-level options" do
		expect(outputs[5]).not_to match(/top-level option/)
	end
end
