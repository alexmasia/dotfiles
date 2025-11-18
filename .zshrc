# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/home/faraday/.local/bin:$PATH
pokemon-colorscripts -r 1-2 --no-title #https://gitlab.com/phoneybadger/pokemon-colorscripts.git
# Inicializa completado
autoload -Uz compinit
zmodload zsh/complist
compinit -i

# Antidote
source "${ZDOTDIR:-$HOME}/.antidote/antidote.zsh"
antidote bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.zsh
source ~/.zsh_plugins.zsh

# (Opcional) tu prompt (Starship u Oh My Posh, etc.)
eval "$(oh-my-posh init zsh --config /home/faraday/.poshthemes/zen.toml)"
alias ls="lsd"
alias ll="lsd -la"
alias lt="lsd --tree"
alias nvconf="nvim /home/faraday/dotfiles/.config/nvim"
alias cdproj="cd /home/faraday/projects"
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
# ~/.zshrc
if command -v tmux >/dev/null 2>&1; then
  # evita bucles si ya estás en tmux o en vscode
  if [ -z "$TMUX" ] && [ -z "$VSCODE_INJECTION" ]; then
    exec tmux
  fi
fi


# opencode
export PATH=/home/faraday/.opencode/bin:$PATH

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/faraday/.lmstudio/bin"
# End of LM Studio CLI section

