module Dependencies
	class Apk < Dependency
		def met?
			execute("apk info | grep -q '^#{name}'$")
		end

		def meet
			execute("apk add #{name}")
		end

		def unmeet
			# do nothing; we don't want to uninstall packages and reinstall them every time
			true
		end

		def should_meet?
			`uname`.chomp == "Linux" && system("which apk > /dev/null 2>&1")
		end
	end
end
