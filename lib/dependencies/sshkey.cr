require "dependencies/dependency"
require "../secrets"

require "ssh2"

module Dependencies
	class Sshkey < Dependency
		DEFAULT_KEY_SIZE = 4096
		DEFAULT_KEY_ALGO = "rsa"
		DEFAULT_KEY_LIFETIME_S = 3600
		DEFAULT_KEY_FILE_COMMENT_COMMAND = "$USER@`hostname -s`"

		def met?
			# we always need to at least update the key lifetime in the agent
			false
		end

		def meet
			Secrets.load

			puts "PASSPHRASE VAR! #{Options.get_s("sshkey.passphrase_var")}"
			varname = Options.get_s("sshkey.passphrase_var") || "USER"
			puts "PASSPHRASE! #{ENV[varname]}"
			puts "SSH_KEY_PASSPHRASE! #{ENV["SSH_KEY_PASSPHRASE"]}"
			puts "passphrase! #{passphrase}"
			Output.warn("\nNo passphrase set for SSH key '#{priv_key_name}'") if passphrase.nil? || passphrase.empty?

			FileUtils.mkdir_p(dir_name) unless File.directory?(dir_name)
			generate_key unless File.exists?(priv_key_name) && File.exists?(pub_key_name)
			add_key if success? && should_add_key?
		end

		def unmeet
			true
		end

		def should_meet?
			true
		end

		private def generate_key
			puts "ssh-keygen -b #{opt_key_size} -t #{opt_key_algo} -f #{priv_key_name} -q -N '#{passphrase}' -C '#{key_file_comment}'"
			execute(
				"ssh-keygen -b #{opt_key_size} -t #{opt_key_algo} -f #{priv_key_name} -q -N '#{passphrase}' -C '#{key_file_comment}'"
			)
		end

		private def add_key
			ENV["DISPLAY"] = "1"
			ENV["SSH_ASKPASS"] = "/bin/echo -e \"$SSH_KEY_PASSPHRASE\"\n"
			system("SSH_ASKPASS='./askpass.sh' ssh-add #{priv_key_name}")
		end

		private def should_add_key?
			ENV["SSH_AUTH_SOCK"] && opt_add_keys?
		end

		private def unencrypted_key
			Net::SSH::KeyFactory.load_private_key(priv_key_name, passphrase.empty? ? nil : passphrase)
		end

		private def key_comment
			Ops.project_name
		end

		private def key_file_comment
			`echo #{opt_key_file_comment_command}`.chomp
		end

		private def dir_name
			`echo #{File.dirname(name)}`.chomp
		end

		private def priv_key_name
			`echo #{name}`.chomp
		end

		private def pub_key_name
			"#{priv_key_name}.pub"
		end

		private def opt_key_size
			Options.get("sshkey.key_size") || DEFAULT_KEY_SIZE
		end

		private def opt_key_algo
			Options.get("sshkey.key_algo") || DEFAULT_KEY_ALGO
		end

		private def passphrase
			`echo $#{opt_passphrase}`.chomp
		end

		private def opt_passphrase
			Options.get_s("sshkey.passphrase_var")
		end

		private def opt_add_keys?
			Options.get("sshkey.add_keys").nil? ? true : Options.get("sshkey.add_keys")
		end

		private def opt_key_lifetime
			Options.get("sshkey.key_lifetime") || DEFAULT_KEY_LIFETIME_S
		end

		private def opt_key_file_comment_command
			Options.get("sshkey.key_file_comment") || DEFAULT_KEY_FILE_COMMENT_COMMAND
		end
	end
end
