# Keep Zsh visually aligned with Fish by using the same Kanagawa Starship config.
export STARSHIP_CONFIG="$HOME/.config/starship.toml"

# Paths
typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  "$HOME/go/bin"
  "$HOME/.cargo/bin"
  "$HOME/.pub-cache/bin"
  "$HOME/.config/ide"
  "$HOME/Library/Android/sdk/platform-tools"
  "$HOME/Library/pnpm"
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /Applications/Docker.app/Contents/Resources/bin
  $path
)

export EDITOR=nvim
export VISUAL=nvim
export GOPATH="$HOME/go"
export PNPM_HOME="$HOME/Library/pnpm"

# History and completion
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt append_history hist_ignore_dups hist_reduce_blanks share_history

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Fish-compatible conveniences
alias ls='ls -p -G'
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'
alias docker-compose='docker compose'
(( $+commands[nvim] )) && alias vim=nvim

# Tool initialization
(( $+commands[fnm] )) && eval "$(fnm env --use-on-cd --shell zsh)"
[[ -r "$HOME/.docker/init-zsh.sh" ]] && source "$HOME/.docker/init-zsh.sh"

# Match the Kanagawa colors from config/fish/config.fish.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#727169'
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]='fg=#DCD7BA'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#C34043'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#D27E99'
ZSH_HIGHLIGHT_STYLES[command]='fg=#7AA89F'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#7AA89F'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#7AA89F'
ZSH_HIGHLIGHT_STYLES[function]='fg=#7AA89F'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#D27E99'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#FF9E64'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#C0A36E'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#C0A36E'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#C0A36E'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#DCD7BA'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#727169'

# Autosuggestions load before syntax highlighting; highlighting must be last.
[[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

(( $+commands[starship] )) && eval "$(starship init zsh)"

[[ -r /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
