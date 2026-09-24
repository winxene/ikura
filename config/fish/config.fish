set -g fish_greeting

# Kanagawa syntax highlighting
set -l foreground DCD7BA normal
set -l selection 2D4F67 brcyan
set -l comment 727169 brblack
set -l red C34043 red
set -l orange FF9E64 brred
set -l yellow C0A36E yellow
set -l green 76946A green
set -l purple 957FB8 magenta
set -l cyan 7AA89F cyan
set -l pink D27E99 brmagenta

set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
# aliases
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
command -qv nvim && alias vim nvim

alias docker-compose "docker compose"

# Paths
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx STARSHIP_CONFIG ~/.config/starship.toml

# Go
set -g GOPATH $HOME/go
set -gx PNPM_HOME "$HOME/Library/pnpm"
fish_add_path /opt/homebrew/bin /opt/homebrew/sbin
fish_add_path $HOME/bin $HOME/.local/bin $GOPATH/bin $HOME/.cargo/bin
fish_add_path $PNPM_HOME $HOME/.pub-cache/bin $HOME/.config/ide
fish_add_path $HOME/Library/Android/sdk/platform-tools
fish_add_path /Applications/Docker.app/Contents/Resources/bin

# fnm
set -gx FNM_DIR "$HOME/.fnm"
if type -q fnm
    fnm env --use-on-cd --shell fish | source
end

set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
  source $LOCAL_CONFIG
end

if status --is-interactive
    starship init fish | source
    zoxide init fish | source
end
