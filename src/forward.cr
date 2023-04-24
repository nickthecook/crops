class Forward
	def initialize(dir : String, args : Array(String))
		@dir = dir
		@args = args
	end

	def run
		Output.notice("Forwarding 'ops #{@args.join(" ")}' to '#{@dir}/'...")

		Dir.cd(@dir)
		Ops.new(@args).run
	end
end
