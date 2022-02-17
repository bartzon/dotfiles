if [[ `uname` == "Darwin" ]]; then
  cd macos
  sh ./install.sh
fi

rake install

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

nvim --noplugin --headless -c 'PlugInstall' -c 'qa'

rm -rf ~/.tmux/plugins/tpm && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

