# frozen_string_literal: true

class Executor
	@exit_code : Process::Status | Nil
	@output : IO::Memory

	getter :exit_code

	def initialize(@command : String)
		@output = IO::Memory.new
	end

	def output : String
		output = @output
		return "" if output.nil?

		output.to_s
	end

	def execute : Bool
		@exit_code = Process.run(command: @command, shell: true, output: @output, error: @output)

		success?
	end

	def success? : Bool
		exit_code = @exit_code
		return true if exit_code.nil?

		exit_code.success?
	end
end
