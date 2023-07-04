# frozen_string_literal: true

RSpec.describe "envdiff" do
	let(:commands) { ["envdiff dev staging"] }

	include_context "ops e2e"

	it "succeeds" do
		expect(exit_codes[0]).to eq(0)
	end

	it "finds dev-only keys" do
		# TODO just couldn't match this output across lines in one regex; this checks that they are in the right order
		dev_vs_staging_idx = outputs[0] =~ /Environment 'dev' defines keys that 'staging' does not:/
		dev_vs_staging_keys_idx = outputs[0] =~ /- \[CONFIG\] two/
		staging_vs_dev_idx = outputs[0] =~ /Environment 'staging' defines keys that 'dev' does not:/
		staging_vs_dev_keys_idx = outputs[0] =~ /- \[CONFIG\] three/

		expect(dev_vs_staging_idx < dev_vs_staging_keys_idx)
		expect(dev_vs_staging_keys_idx < staging_vs_dev_idx)
		expect(staging_vs_dev_idx < staging_vs_dev_keys_idx)
	end

	it "warns about missing secrets" do
		expect(outputs[0]).to match(/File 'config\/dev\/secrets.json' does not exist./)
		expect(outputs[0]).to match(/File 'config\/staging\/secrets.json' does not exist./)
	end

	it "does not output ignored keys" do
		expect(outputs[0]).not_to match(/ignore_me/)
		expect(outputs[0]).not_to match(/ignore_me_too/)
	end
end
