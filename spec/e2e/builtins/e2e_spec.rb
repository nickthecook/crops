# frozen_string_literal: true

RSpec.describe "builtins" do
	let(:commands) do
		%w[version --version help --help]
	end

	include_context "ops e2e"

	it "succeeds" do
		expect(exit_codes).to all(eq(0))
	end

	context "when action arg is prefixed with --" do
		let(:commands) { ["--test", "--test-watch"] }

		it "exits with unknown action error code" do
			expect(exit_codes.first).to eq(65)
		end
	end

	context "when action arg is prefixed with -" do
		let(:commands) { %w[-h -v] }

		it "succeeds" do
			expect(exit_codes).to all(eq(0))
		end

		context "when action name is more than one character" do
			let(:commands) { %w[-help -version] }

			it "fails" do
				expect(exit_codes).to all(eq(65))
			end
		end
	end

	context "when an action occludes a builtin" do
		let(:commands) { ["init"] }

		it "runs the action" do
			expect(outputs.first).to match(/Imma firin mah lazer!/)
		end

		context "when running a builtin occluded by an action" do
			let(:commands) { ["--init"] }

			it "runs the builtin" do
				expect(exit_codes.first).to eq(1)
				expect(outputs.first).to match(/ops\.yml exists; not initializing\./)
			end
		end
	end
end
