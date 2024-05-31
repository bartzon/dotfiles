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
PATH=~/.bin:$PATH:`npm config get prefix`/bin
PATH="/opt/homebrew/opt/ruby/bin:$PATH"

GPG_TTY=$(tty)
export GPG_TTY

if [ "$TMUX" = "" ]; then tmux new -As0; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zsh/functions/fzf-tab/fzf-tab.plugin.zsh ] && source ~/.zsh/functions/fzf-tab/fzf-tab.plugin.zsh

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# cloudplatform: add Shopify clusters to your local kubernetes config
export KUBECONFIG=${KUBECONFIG:+$KUBECONFIG:}/Users/bartzonneveld/.kube/config:/Users/bartzonneveld/.kube/config.shopify.cloudplatform
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/opt/node@20/bin:$PATH"
