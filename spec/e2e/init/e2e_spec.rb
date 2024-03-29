# frozen_string_literal: true

RSpec.describe "init" do
	let(:commands) { [] }

	include_context "ops e2e"

	after do
		`rm -f ops.yml`
	end

	let(:ops_yml) { File.read("ops.yml") }
	let(:exit_code) { result[EXIT_CODE_IDX] }
	let(:output) { result[OUTPUT_IDX] }

	shared_examples "inits ops.yml" do |ops_args|
		let!(:result) { ops(ops_args) }

		it "succeeds" do
			expect(result[EXIT_CODE_IDX]).to eq(0)
		end

		it "outputs valid YAML" do
			expect { YAML.safe_load(ops_yml) }.not_to raise_exception
		end
	end

	shared_examples "says file already exists" do
		it "exits with 1" do
			expect(exit_code).to eq(1)
		end

		it "prints an error" do
			expect(output).to match(/File 'ops.yml' exists; not initializing/)
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

	context "when template path is given" do
		include_examples "inits ops.yml", "init some_other_dir/template.yml"

		it "outputs the correct template" do
			expect(ops_yml).to match(/- ftw/)
		end
	end

	context "when template cannot be found" do
		let!(:result) { ops("init custom") }

		it "exits with non-zero" do
			expect(exit_code).to eq(1)
		end

		it "prints an error" do
			expect(output).to match(/Could not find template for 'custom'/)
		end
	end

	context "when ops.yml already exists" do
		let!(:result) { `touch ops.yml` && ops("init") }

		include_examples "says file already exists"
	end

	context "when ops.yaml already exists" do
		let!(:result) { `touch ops.yaml` && ops("init") }

		include_examples "says file already exists"
	end
end
