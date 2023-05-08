# frozen_string_literal: true

RSpec.describe "init" do
	include_context "ops e2e"

	before(:all) do
		Dir.chdir(__dir__)

		remove_untracked_files
	end

	after do
		`rm -f ops.yml`
	end

	let(:ops_yml) { File.read("ops.yml") }

	shared_examples "inits ops.yml" do |ops_args|
		let!(:result) { run_ops("../../../build/ops #{ops_args}") }

		it "succeeds" do
			expect(result[EXIT_CODE_IDX]).to eq(0)
		end

		it "outputs valid YAML" do
			expect { YAML.safe_load(ops_yml) }.not_to raise_exception
		end
	end

	include_examples "inits ops.yml", "init"

	it "outputs the correct template" do
		expect(ops_yml).to match(/docker-compose up -d/)
	end

	describe "terraform" do
		include_examples "inits ops.yml", "init terraform"

		it "outputs the correct template" do
			expect(ops_yml).to match(/ops apply --auto-approve/)
		end
	end

	describe "ruby" do
		include_examples "inits ops.yml", "init ruby"

		it "outputs the correct template" do
			expect(ops_yml).to match(/rerun -x ops test/)
		end
	end
end
