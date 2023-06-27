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

rake install

python3 -m pip install --user --upgrade pynvim

rm -rf ~/.tmux/plugins/tpm && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

