if ! command -v bat &> /dev/null; then
  sudo apt-get install -y bat
fi

if ! command -v exa &> /dev/null; then
  sudo apt-get install -y exa
fi

if ! command -v ripgrep &> /dev/null; then
  sudo apt-get install -y ripgrep
fi

if ! command -v diff-so-fancy &> /dev/null; then
  npm i -g diff-so-fancy
fi

