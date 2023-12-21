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

# aliases
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
command -qv nvim && alias vim nvim

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

# NodeJS
set -gx PATH node_modules/.bin $PATH

# Go
set -g GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

# Flutter
set -gx PATH $PATH /Library/flutter/bin

# Rust
set -gx PATH $PATH $HOME/.cargo/bin

# Python
set -gx PATH $PATH $HOME/Library/Python/3.9/bin

# Ruby
set -gx PATH $PATH $HOME/.gem/ruby/3.0.0/bin

# Java
set -gx PATH $PATH /Library/Java/JavaVirtualMachines/jdk-16.0.1.jdk/Contents/Home/bin

# Firebase cli
set -gx PATH $PATH $HOME/.pub-cache/bin

# NVM
function __check_rvm --on-variable PWD --description 'Do nvm stuff'
  status --is-command-substitution; and return

  if test -f .nvmrc; and test -r .nvmrc;
    nvm use
  else
  end
end

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
