if status is-interactive
  # Path
  fish_add_path -p ~/.toolbox/bin
  fish_add_path -p ~/.bin

  # Activate homebrew
  eval (/opt/homebrew/bin/brew shellenv)

  # Activate mise (from homebrew)
  if type -q mise
    mise activate fish | source
  end

  # Activate zoxide (from homebrew)
  if type -q zoxide
    zoxide init fish | source
  end

  # Prompt (from homebrew)
  if type -q starship
    starship init fish | source
  end


  # VSCode integration
  string match -q "$TERM_PROGRAM" "vscode"
  and . (code --locate-shell-integration-path fish)

  # General aliases
  alias cat="bat -p"
  alias cd=z

  set -gx EDITOR nvim
end

