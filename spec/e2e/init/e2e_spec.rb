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
			puts result[OUTPUT_IDX]
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

	context "when template is in user template dir" do
		let(:ops_env_vars) { { "OPS__INIT__TEMPLATE_DIR" => "templates" } }

		include_examples "inits ops.yml", "init custom"

		it "outputs the correct template" do
			expect(ops_yml).to match(/- wtf/)
		end
	end

	context "when template cannot be found" do
		let!(:result) { run_ops("../../../build/ops init custom") }
		let(:exit_code) { result[EXIT_CODE_IDX] }
		let(:output) { result[OUTPUT_IDX] }

		it "exits with non-zero" do
			expect(exit_code).to eq(1)
		end

		it "prints an error" do
			expect(output).to match(/Could not find template for 'custom'/)
		end
	end
end
