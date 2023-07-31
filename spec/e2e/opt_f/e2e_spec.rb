# frozen_string_literal: true

RSpec.describe "forwards" do
	let(:commands) do
		[
			"-f app/ops.yml say-name",
			"-f app/ops.yml ls -l",
			"-f",
			"--file app/ops.yml say-name",
		]
	end

	include_context "ops e2e"

	context "when running action without params" do
		it "succeeds" do
			expect(exit_codes[0]).to eq(0)
			expect(exit_codes[3]).to eq(0)
		end

		it "runs action with no args from 'app/ops.yml'" do
			expect(outputs[0]).to match(/Hello, my name is Leeeeeroy/)
			expect(outputs[3]).to match(/Hello, my name is Leeeeeroy/)
		end
	end

	context "when running action with option passed to it" do
		it "succeeds" do
			expect(exit_codes[1]).to eq(0)
		end

		it "gets the expected output" do
			expect(outputs[1]).to match(/drwxr.xr-x/)
		end
	end

	context "when given -f without another param" do
		it "exits with an error code" do
			expect(exit_codes[2]).to eq(1)
		end

		it "prints usage" do
			expect(outputs[2]).to match(/\e\[31mUsage: ops/)
		end
	end
end
