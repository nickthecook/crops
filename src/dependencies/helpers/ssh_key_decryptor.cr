module Dependencies
  module Helpers
    class SshKeyDecryptor
      getter executor : Executor

      @plaintext_key : String | Nil
      @temp_key_file : File | Nil

      def initialize(source_key_path : String, passphrase : String)
        @source_key_path = source_key_path
        @passphrase = passphrase
        @executor = Executor.new("echo -e '\n\n' | ssh-keygen -q -f '#{temp_key_file.path}' -p -P '#{@passphrase}' -N ''")
      end

      def plaintext_key : String | Nil
        @plaintext_key ||= begin
        Output.debug("Creating temporary key file '#{temp_key_file.path}'...")
        FileUtils.cp(@source_key_path, temp_key_file.path)
          plaintext = decrypt_key

          Output.debug("Deleting temporary key file '#{temp_key_file.path}'...")
          File.delete(temp_key_file.path)

          plaintext
        end
      end

      private def temp_key_file
        @temp_key_file ||= File.tempfile("ops")
      end

      private def decrypt_key : String | Nil
        Output.debug("Decrypting key with passphrase...")
        if executor.execute
          Output.debug("Key decrypted in #{temp_key_file.path}")

          temp_key_file.gets_to_end
        else
          Output.debug("Key decryption failed: #{executor.output}")
        end
      end
    end
  end
end
