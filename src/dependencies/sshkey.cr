require "dependencies/dependency"
require "../secrets"
require "dependencies/helpers/ssh_key_decryptor"

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
			Output.debug("Generating SSH key with passphrase...")
			execute(
				"ssh-keygen -b #{opt_key_size} -t #{opt_key_algo} -f #{priv_key_name} -q -N '#{passphrase}' -C '#{key_file_comment}'"
				)
		end

		private def add_key
			Output.debug("Calling SshKeyDecryptor...")
			decryptor.plaintext_key
			@executor = l_executor = decryptor.executor
			return unless l_executor.success?
			Output.debug("Adding decrypted SSH key...")
			execute("ssh-add -q - <<~EOF\n#{decryptor.plaintext_key}\nEOF &>/dev/null")
		end

		private def should_add_key?
			ENV["SSH_AUTH_SOCK"] && opt_add_keys?
		end

		private def decryptor
			@decryptor ||= Helpers::SshKeyDecryptor.new(priv_key_name, passphrase)
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
			Options.get_s("sshkey.passphrase_var") || "SSH_KEY_PASSPHRASE"
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
