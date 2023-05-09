# frozen_string_literal: true

require_relative '../ssh_spec_helper'

RSpec.describe "ssh key with passphrase var" do
	let(:commands) { ["up"] }

	include_context "ops e2e"

	it "succeeds" do
		expect(exit_code).to eq(0)
	end

	it "generates a key with a passphrase" do
		expect(has_passphrase?("user@host")).to be true
	end

	include_examples "creates an SSH key", "user@host"
end
