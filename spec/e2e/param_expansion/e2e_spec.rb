# frozen_string_literal: true

RSpec.describe "forwards" do
	let(:commands) do
		[
			"expansion one two three",
			"expansion one two \"three four five\"",
			"numargs '1 2' 3",
			["shebang_bash one two three \"four five\"", { stdin_data: "goodbye, world\n" }],
			["shebang_python world earth", { stdin_data: "goodbye, world" }],
			["shebang_ruby world earth", { stdin_data: "goodbye, world" }],
		]
	end

	include_context "ops e2e"

	it "succeeds" do
		expect(exit_codes).to all eq(0)
	end

	it "performs param expansion when enabled in config" do
		expect(outputs[0]).to match(/\nFirst: one\nSecond: two\nThird: three\n$/)
	end

	it "preserves shell-quoting when enabled in config" do
		expect(outputs[1]).to match(/\nFirst: one\nSecond: two\nThird: three four five\n$/)
	end

	it "preserves arg count when enabled in config" do
		expect(outputs[2]).to match(/2\n$/)
	end

	it "interprets bash shebang and prints stdin when enabled in config" do
		expect(outputs[3]).to match(/\nFirst: one\nSecond: two\nOther: three\nOther: four five\ngoodbye, world\n$/)
	end

	it "interprets python shebang and prints stdin when enabled in config" do
		expect(outputs[4]).to match(/\nhello, \+world>> earth\+\ngoodbye, world\n$/)
	end

	it "interprets ruby shebang and prints stdin when enabled in config" do
		expect(outputs[5]).to match(/\nhello, \+world>> earth\+\ngoodbye, world\n$/)
	end
end
