if ! command -v batcat &> /dev/null; then
  sudo apt-get install -y bat
  alias batcat='batcat --style=numbers'
  echo "alias batcat='batcat --style=numbers'" >> ~/.zsh/aliases
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

if [ -f /etc/spin/secrets/copilot_hosts.json ]; then
  mkdir -p "${HOME}/.config/github-copilot"
  cp /etc/spin/secrets/copilot_hosts.json "${HOME}/.config/github-copilot/hosts.json"
fi
