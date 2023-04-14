if ! command -v batcat &> /dev/null; then
  sudo apt-get install -y bat
  alias bat="/usr/bin/batcat"
  alias cat="/usr/bin/batcat"
fi

if ! command -v exa &> /dev/null; then
  sudo apt-get install -y exa
fi

if ! command -v ripgrep &> /dev/null; then
  sudo apt-get install -y ripgrep
fi

if ! command -v lsd &> /dev/null; then
  sudo apt-get install -y lsd
fi
