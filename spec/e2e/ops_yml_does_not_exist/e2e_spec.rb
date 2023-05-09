# frozen_string_literal: true

RSpec.describe "no actions" do
	include_context "ops e2e"

	before(:all) do
		Dir.chdir(__dir__)

		remove_untracked_files
	end

	after do
		`rm -f ops.yml`
	end

	let(:success_commands) do
		[
			"../../../build/ops version",
			"../../../build/ops init",
			"../../../build/ops help"
		]
	end
	let(:error_commands) do
		[
			"../../../build/ops up",
			"../../../build/ops down",
			"../../../build/ops test"
		]
	end
	let(:success_results) { success_commands.map { |cmd| run_ops(cmd) } }
	let(:error_results) { error_commands.map { |cmd| run_ops(cmd) } }
	let(:success_exit_codes) { success_results.map { |result| result[EXIT_CODE_IDX] } }
	let(:error_exit_codes) { error_results.map { |result| result[EXIT_CODE_IDX] } }
	let(:error_outputs) { error_results.map { |result| result[OUTPUT_IDX] } }

	it "succeeds when action does not require ops.yml" do
		expect(success_exit_codes).to all(eq(0))
	end

	it "fails when action does require ops.yml" do
		expect(error_exit_codes).to all(eq(72))
	end

	it "outputs an error message when it fails" do
		expect(error_outputs).to all match(/File 'ops.yml' does not exist./)
	end
end
