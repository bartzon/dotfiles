#!/bin/zsh

if ! command -v batcat &> /dev/null; then
  sudo apt-get install -y bat
  alias bat="/usr/bin/batcat"
  alias cat="/usr/bin/batcat"
fi

if ! command -v ripgrep &> /dev/null; then
  sudo apt-get install -y ripgrep
fi

if ! command -v lsd &> /dev/null; then
  wget https://github.com/lsd-rs/lsd/releases/download/0.23.1/lsd_0.23.1_amd64.deb
  sudo dpkg -i lsd_0.23.1_amd64.deb
  rm -f lsd_0.23.1_amd64.deb
fi

if ! command -v delta &> /dev/null; then
  wget https://github.com/dandavison/delta/releases/download/0.16.5/git-delta_0.16.5_amd64.deb
  sudo dpkg -i git-delta_0.16.5_amd64.deb
  rm -f git-delta_0.16.5_amd64.deb
fi
