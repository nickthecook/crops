# frozen_string_literal: true

require_relative '../ssh_spec_helper'

RSpec.describe "ssh key with passphrase" do
	let(:commands) { ["up"] }

	include_context "ops e2e"

	it "succeeds" do
		expect(exit_code).to eq(0)
	end

	include_examples "creates an SSH key", "user@host"
end
