. ~/.zsh/config
. ~/.zsh/aliases
. ~/.zsh/opts
. ~/.zsh/autocomplete

if [[ -f /opt/dev/dev.sh ]]
then
  source /opt/dev/dev.sh
[[ -f /opt/dev/sh/chruby/chruby.sh ]] && { type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; } }
  [[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)
  PATH=/opt/homebrew/sbin:$PATH
else
  [[ -f /usr/local/share/chruby/chruby.sh ]] && source /usr/local/share/chruby/chruby.sh
  [[ -x /usr/local/bin/brew ]] && eval $(/usr/local/bin/brew shellenv)
fi

PATH=~/.bin:$PATH

GPG_TTY=$(tty)
export GPG_TTY

if [ "$TMUX" = "" ]; then tmux new -As0; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
