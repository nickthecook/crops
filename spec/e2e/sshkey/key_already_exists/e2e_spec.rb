# frozen_string_literal: true

require_relative '../ssh_spec_helper'

RSpec.describe "ssh key with passphrase" do
	let(:commands) { ["up"] }

	include_context "ops e2e"

	before(:all) do
		system("ssh-add -D &>/dev/null")
	end

	before do
		system("chmod 600 persistent@host")
	end

	it "succeeds" do
		expect(exit_code).to eq(0)
	end

	include_examples "SSH key is added to agent", "persistent"

	context "when key permissions are too permissive for ssh-keygen" do
		before do
			system("chmod 644 persistent@host")
			system("ssh-add -D &>/dev/null")
			ops("up sshkey")
		end

		include_examples "SSH key is added to agent", "persistent"
	end
end
