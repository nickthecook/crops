# frozen_string_literal: true

require_relative '../ssh_spec_helper'

RSpec.describe "ssh key with passphrase var" do
	let(:commands) { ["up"] }

	include_context "ops e2e"

	it "prints a nice little error" do
		expect(output).to match(/You must specify a name for the sshkey/)
	end
end
