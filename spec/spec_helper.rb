# frozen_string_literal: true

require 'pry-byebug'

ENV['environment'] = "test"
ENV['EJSON_KEYDIR'] = "./spec/ejson_keys"
ENV.delete("SSH_KEY_PASSPHRASE")

RSpec.configure do |config|
	config.expect_with :rspec do |expectations|
		expectations.include_chain_clauses_in_custom_matcher_descriptions = true
	end

	config.mock_with :rspec do |mocks|
		mocks.verify_partial_doubles = true
	end

	config.shared_context_metadata_behavior = :apply_to_host_groups

	config.order = :random
	Kernel.srand config.seed
end

require_relative "e2e/e2e_spec_helper"
