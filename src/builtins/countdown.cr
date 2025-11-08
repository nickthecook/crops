module Builtins
	class Countdown < Builtin
		class ArgumentError < RuntimeError; end

		def self.description
			"Like `sleep`, but displays time remaining in terminal."
		end

		def run
			check_args

			(0...sleep_seconds).each do |i|
				Output.print("\r      \r#{sleep_seconds - i}")
				sleep(Time::Span.new(seconds: 1))
			end
			Output.out("\rCountdown complete after #{sleep_seconds}s.")

			true
		end

		private def check_args
			raise ArgumentError.new("Argument must be a positive integer") unless @args.first && @args.first.to_i
		end

		private def sleep_seconds
			@args.first.not_nil!.to_i
		end
	end
end
