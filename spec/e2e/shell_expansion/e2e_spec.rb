# frozen_string_literal: true

RSpec.describe "forwards" do
	let(:commands) do
		[
			"expansion",
			"no-expansion",
			"numargs '1 2' 3",
			"numargs-no-expansion '1 2' 3",
			"numargs-combined '1 2' 3",
			"numargs-combined-no-expansion '1 2' 3"
		]
	end

	include_context "ops e2e"

	it "succeeds" do
		expect(exit_codes).to all eq(0)
	end

	it "performs shell expansion by default" do
		expect(outputs[0]).to match(/\nhello\n/)
	end

	it "does not perform shell expansion when disabled in config" do
		expect(outputs[1]).to match(/\n"hello"\n/)
	end

	it "expands args by default" do
		expect(outputs[2]).to match(/2\n$/)
	end

	it "preserves arg count when disabled in config" do
		expect(outputs[3]).to match(/2\n$/)
	end

	it "concatenates args in config with args on command-line" do
		expect(outputs[4]).to match(/3\n$/)
	end

	it "concatenates args and preserves count" do
		expect(outputs[5]).to match(/3\n$/)
	end
end
