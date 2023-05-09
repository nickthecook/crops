# frozen_string_literal: true

RSpec.describe "environment_loading" do
	let(:commands) { ["print_env"] }

	include_context "ops e2e"

	it "succeeds" do
		expect(exit_code).to eq(0)
	end

	it "sets environment variables based on variables loaded from config" do
		expect(output).to match(/ENV_CONFIG_VAR=from config/)
	end

	it "sets environment variables based on variables loaded from secrets" do
		expect(output).to match(/ENV_SECRETS_VAR=from secrets/)
	end
end
