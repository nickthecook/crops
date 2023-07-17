# frozen_string_literal: true

RSpec.describe "no actions" do
	let(:commands) { [] }

	include_context "ops e2e"

	after do
		`rm -f ops.yml`
	end

	let(:success_commands) do
		%w[version --version v -v init help --help h -h]
	end
	let(:error_commands) do
		%w[up down test]
	end
	let(:success_results) { success_commands.map { |cmd| ops(cmd) } }
	let(:error_results) { error_commands.map { |cmd| ops(cmd) } }
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
