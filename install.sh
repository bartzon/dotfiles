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

npm install -g eslint_d

git submodule update --init --recursive

rake install
vale sync
git clone https://github.com/wfxr/forgit.git ~/.bin/forgit

python3 -m pip install --user --upgrade pynvim

nvim +":q"
