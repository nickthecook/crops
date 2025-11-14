# frozen_string_literal: true

require 'pry-byebug'

ENV['environment'] = "test"
ENV['EJSON_KEYDIR'] = "./spec/ejson_keys"
ENV.delete("SSH_KEY_PASSPHRASE")

RSpec.configure do |config|
	config.example_status_persistence_file_path = ".rspec_status"

	config.expect_with :rspec do |expectations|
		expectations.include_chain_clauses_in_custom_matcher_descriptions = true
	end

	config.mock_with :rspec do |mocks|
		mocks.verify_partial_doubles = true
	end

	config.shared_context_metadata_behavior = :apply_to_host_groups

	config.order = :random
	Kernel.srand config.seed

	config.before(:each) do |example|
		# each spec needs to be run from its own dir
		example_path = File.join(
			__dir__,
			"..",
			example.metadata[:example_group][:file_path]
		)
		Dir.chdir(File.dirname(example_path))

		remove_untracked_files
	end

	config.after(:suite) do
		`ssh-add -D &>/dev/null`
	end
end

require_relative "e2e/e2e_spec_helper"
