set fish_greeting "https://stump-zydeco-616.notion.site/Fish-Chan-de117e5bda73414882aa237bd1236d28 for switching back to zsh"


set -gx TERM xterm-256color

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always
set -g theme_display_user_hostname yes
set -g theme_display_vi_mode yes

set -g theme_powerline_fonts yes
set -g theme_nerd_fonts yes
set -g theme_display_git_stashed_verbose yes
set -g theme_display_git_master_branch yes
set -g theme_display_git_untracked yes
set -g theme_display_git_dirty yes
set -g theme_display_nvm yes
set -g theme_display_virtualenv yes

set theme "kanagawa" 

switch $theme
    case "default"
        # Enable syntax highlighting
        set -g fish_color_autosuggestion brblack
        set -g fish_color_cancel -r
        set -g fish_color_command brwhite --bold
        set -g fish_color_comment brgreen
        set -g fish_color_cwd brcyan
        set -g fish_color_cwd_root brblack
        set -g fish_color_directory brcyan
        set -g fish_color_end brblack
        set -g fish_color_error -r
        set -g fish_color_escape brcyan
        set -g fish_color_history_current --background=brblack --bold
        set -g fish_color_host brred
        set -g fish_color_match --background=yellow --bold
        set -g fish_color_normal brblack
        set -g fish_color_operator brblack
        set -g fish_color_param brblack
        set -g fish_color_quote brmagenta
        set -g fish_color_redirection brblack
        set -g fish_color_search_match --background=yellow --bold
        set -g fish_color_selection --background=brblack --bold
        set -g fish_color_status -r
        set -g fish_color_user brred
    case "kanagawa"
        #Color
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

        # Enable syntax highlighting
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
        #Completion Pager Colors
        set -g fish_pager_color_progress $comment
        set -g fish_pager_color_prefix $cyan
        set -g fish_pager_color_completion $foreground
        set -g fish_pager_color_description $comment
end
# aliases
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
command -qv nvim && alias vim nvim

alias docker-compose "docker compose"

#Bindings

bind \cr accept-autosuggestion
bind \cs fzf-file-widget
bind \cF fzf-cd-widget
bind \es toggle-vi-mode
bind \ew widget-edit

# Paths
set -gx PATH /opt/homebrew/bin/ $PATH
set -gx EDITOR nvim
set -gx VISUAL nvim

# starship
set -gx STARSHIP_CONFIG ~/.config/starship.toml
set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# tmux
function fish_postexec
    ~/.config/tmux/scripts/tmux-rename-session.sh
end

# NodeJS
set -gx PATH node_modules/.bin $PATH

# Go
set -g GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

# Flutter
set -gx PATH $PATH /Library/flutter/bin

# Rust
set -gx PATH $PATH $HOME/.cargo/bin

# Dart
set -gx PATH $PATH /Library/flutter/bin/cache/dart-sdk/bin

# Docker
set -gx PATH $PATH /Applications/Docker.app/Contents/Resources/bin

# docker-compose
set -gx PATH $PATH /usr/local/bin/docker-compose

# Python
set -gx PATH $PATH $HOME/Library/Python/3.9/bin

# Ruby
set -gx PATH $PATH $HOME/.gem/ruby/3.0.0/bin

# Java
set -gx PATH $PATH /Library/Java/JavaVirtualMachines/jdk-16.0.1.jdk/Contents/Home/bin

# Firebase cli
set -gx PATH $PATH $HOME/.pub-cache/bin

# set path to ide script
set -gx PATH $PATH $HOME/.config/ide/ide.sh

# set adb path
set -gx PATH $PATH /Users/ikura/Library/Android/sdk/platform-tools

# NVM
function __check_rvm --on-variable PWD --description 'Do nvm stuff'
  status --is-command-substitution; and return

  if test -f .nvmrc; and test -r .nvmrc;
    nvm use
  else
  end
end

function nvm
  bass source (brew --prefix nvm)/nvm.sh --no-use ';' nvm $argv
end

set -gx NVM_DIR (brew --prefix nvm)/nvm
nvm use default --silent

switch (uname)
  case Darwin
    source (dirname (status --current-filename))/config-osx.fish
  case Linux
    source (dirname (status --current-filename))/config-linux.fish
  case '*'
    source (dirname (status --current-filename))/config-windows.fish
end

set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
  source $LOCAL_CONFIG
end

if status --is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source 
end

# pnpm
set -gx PNPM_HOME "/Users/ikura/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/homebrew/anaconda3/bin/conda
    eval /opt/homebrew/anaconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/opt/homebrew/anaconda3/etc/fish/conf.d/conda.fish"
        . "/opt/homebrew/anaconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/opt/homebrew/anaconda3/bin" $PATH
    end
end

set _CONDA_ROOT "/opt/homebrew/anaconda3"
# <<< conda initialize <<<

