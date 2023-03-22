# frozen_string_literal: true

require "concurrent"

module Builtins
	class Countdown < Builtin
		USAGE_STRING = "Usage: ops countdown <seconds>"

		def self.description
			"Like `sleep`, but displays time remaining in terminal."
		end

		def run
			check_args

			timer_task.execute

			while timer_task.running?
				sleep(1)
				timer_task.shutdown if task_complete?
			end
			Output.out("\rCountdown complete after #{sleep_seconds}s.")

			true
		end

		private def check_args
			check_arg_count
			check_arg_is_positive_int
		end

		private def check_arg_count
			raise Builtin::ArgumentError, USAGE_STRING unless args.length == 1
		end

		private def check_arg_is_positive_int
			raise Builtin::ArgumentError, USAGE_STRING unless sleep_seconds.positive?
		# raised when the arg is not an int
		rescue ::ArgumentError
			raise Builtin::ArgumentError, USAGE_STRING
		end

		private def timer_task
			@timer_task ||= Concurrent::TimerTask.new(run_now: true, execution_interval: 1) do
				Output.print("\r      \r#{seconds_left}")
			end
		end

		private def sleep_seconds
			args.first.to_i
		end

		private def task_start_time
			@task_start_time ||= Time.now
		end

		private def task_end_time
			@task_end_time ||= task_start_time + sleep_seconds
		end

		private def task_complete?
			Time.now > task_end_time
		end

		private def seconds_left
			(task_end_time - Time.now + 1).to_i
		end
	end
end
