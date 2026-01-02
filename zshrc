#!/bin/zsh

. ~/.zsh/config
. ~/.zsh/aliases
. ~/.zsh/opts
. ~/.zsh/autocomplete

# if [[ -f /opt/dev/dev.sh ]]
# then
#   [[ -f /opt/dev/sh/chruby/chruby.sh ]] && { type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; } }
#   [[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)
#   PATH=/opt/homebrew/sbin:$PATH
  unalias dev 2>/dev/null || true
  source /opt/dev/dev.sh
# else
#   [[ -f /usr/local/share/chruby/chruby.sh ]] && source /usr/local/share/chruby/chruby.sh
#   [[ -x /usr/local/bin/brew ]] && eval $(/usr/local/bin/brew shellenv)
# fi

# dev wrapper with LaMetric notifications (must be after dev.sh)
alias dev='~/.bin/dev-wrapper'

PATH=~/.bin:$PATH
PATH="/usr/local/opt/ruby/bin:$PATH"
PATH="/opt/homebrew/opt/node@20/bin:$PATH"
PATH="/opt/homebrew/opt/ruby/bin:$PATH"

GPG_TTY=$(tty)
export GPG_TTY

# if [ "$TMUX" = "" ]; then tmux new -As0; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zsh/functions/fzf-tab/fzf-tab.plugin.zsh ] && source ~/.zsh/functions/fzf-tab/fzf-tab.plugin.zsh

# Fix for fzf history widget
if type fzf-history-widget > /dev/null; then
  # Override the fzf-history-widget to fix the height error
  fzf-history-widget() {
    local selected
    setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases noglob nobash_rematch 2> /dev/null
    selected="$(fc -rl 1 | awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' | \
      fzf --height 40% --layout=reverse --border -n2..,.. --scheme=history --bind=ctrl-r:toggle-sort --query="${LBUFFER}" +m)"
    local ret=$?
    if [ -n "$selected" ]; then
      if [[ $(awk '{print $1; exit}' <<< "$selected") =~ ^[1-9][0-9]* ]]; then
        zle vi-fetch-history -n $MATCH
      else
        LBUFFER="$selected"
      fi
    fi
    zle reset-prompt
    return $ret
  }
fi

source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.bin/forgit/forgit.plugin.zsh

[[ -f ~/.openairc ]] && source ~/.openairc

# cloudplatform: add Shopify clusters to your local kubernetes config
export KUBECONFIG=${KUBECONFIG:+$KUBECONFIG:}/Users/bartzonneveld/.kube/config:/Users/bartzonneveld/.kube/config.shopify.cloudplatform

# Added by tec agent
[[ -x /Users/bartzonneveld/.local/state/tec/profiles/base/current/global/init ]] && eval "$(/Users/bartzonneveld/.local/state/tec/profiles/base/current/global/init zsh)"
