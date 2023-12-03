#!/bin/zsh

curdir=$(pwd)

if [[ `uname` == "Darwin" ]]; then
  cd macos
  sh ./install.sh
  cd $curdir
fi

if [[ `uname` == "Linux" ]]; then
  cd linux
  sh ./install.sh
  cd $curdir
fi

# install neovim providers
gem install neovim
npm install -g neovim

git submodule update --init --recursive

rake install

python3 -m pip install --user --upgrade pynvim

rm -rf ~/.tmux/plugins/tpm && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

