module Builtins
  module Helpers
    module CompletionScripts
      COMPLETION_SCRIPTS = { "bash" => BASH_COMPLETION_SCRIPT, "zsh" => ZSH_COMPLETION_SCRIPT, "fish" => FISH_COMPLETION_SCRIPT }

      BASH_COMPLETION_SCRIPT = <<-BASH_COMPLETION_SCRIPT
      __ops_completion() {
        local curr prev
        curr="${COMP_WORDS[COMP_CWORD]}"

        prev="${COMP_WORDS[*]:0:COMP_CWORD}"

        local suggestions
        suggestions=$(ops completion -- "curr=$curr" "prev=$prev" 2>/dev/null) || return

        COMPREPLY=()

        if [[ -z $suggestions ]]; then
            compopt -o default
            return 0
        fi

        while read line; do
          [ -n "$line" ] && COMPREPLY+=("$line")
        done <<< "$suggestions"
      }

      complete -F __ops_completion ops
      BASH_COMPLETION_SCRIPT

      ZSH_COMPLETION_SCRIPT = <<-ZSH_COMPLETION_SCRIPT
      __ops_completion() {
        local curr
        curr="${words[CURRENT]}"

        local prev=""
        local i=1
        for ((i=1; i < CURRENT; i++)); do
          prev="${prev} ${words[i]}"
        done

        local suggestions
        suggestions=$(ops completion -- "curr=$curr" "prev=$prev" 2>/dev/null) || return

        local -a compadd_args

        if (( $#suggestions > 0 )); then
          compadd_args=("${(f)suggestions}")
          compadd -- "${compadd_args[@]}"
        else
          _files
        fi
      }

      compdef __ops_completion ops
      ZSH_COMPLETION_SCRIPT

      FISH_COMPLETION_SCRIPT = <<-FISH_COMPLETION_SCRIPT
      function __ops_completion
        set -l curr (commandline -ct)
        set -l prev (commandline -cx)

        set -l suggestions $(ops completion -- "curr=$curr" "prev=$prev" 2>/dev/null); or return

        if test (count $suggestions) -eq 0
          __fish_complete_path "$curr"
        else
          for suggestion in $suggestions
            echo $suggestion
          end
        end
      end

      complete -c ops -f -a "(__ops_completion)"
      FISH_COMPLETION_SCRIPT
    end
  end
end
