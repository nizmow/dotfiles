if status is-interactive
  # Path
  fish_add_path -p ~/.toolbox/bin
  fish_add_path -p ~/.bin

  # Activate homebrew
  if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
  else if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  end

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

  # Fish doesn't seem to understand wezterm
  set fish_vi_force_cursor 1
  # Emulates vim's cursor shape behavior
  # Set the normal and visual mode cursors to a block
  set fish_cursor_default block
  # Set the insert mode cursor to a line
  set fish_cursor_insert line
  # Set the replace mode cursors to an underscore
  set fish_cursor_replace_one underscore
  set fish_cursor_replace underscore
  # Set the external cursor to a line. The external cursor appears when a command is started.
  # The cursor shape takes the value of fish_cursor_default when fish_cursor_external is not specified.
  set fish_cursor_external line
  # The following variable can be used to configure cursor shape in
  # visual mode, but due to fish_cursor_default, is redundant here
  set fish_cursor_visual block

  fish_vi_key_bindings
end

function fish_user_key_bindings
    bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"
end

