# frozen_string_literal: true

require_relative '../ssh_spec_helper'

# frozen_string_literal: true

RSpec.describe "ssh key with configured algorithm" do
	let(:commands) { ["up"] }

	include_context "ops e2e"

	it "succeeds" do
		expect(exit_code).to eq(0)
	end

	it "generates a key with the configured algorithm" do
		expect(`ssh-keygen -l -f user@host`).to match(/(ED25519)/)
	end

	include_examples "creates an SSH key", "user@host"
end
