osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"~/code/dotfiles/macos/background.jpeg\" as POSIX file"

sh brew.sh
sh defaults.sh

python3.9 -m pip install --upgrade pip
pip3 install gcalendar

cd ../bin/agenda
bundle install
bundle exec whenever --update-crontab
cd -

cp ./'Monaco Nerd Font Complete Mono.otf' ~/Library/Fonts
cp ./'Monaco Nerd Font Complete.otf' ~/Library/Fonts

asdf plugin add ruby
asdf install ruby 3.1.1
asdf global ruby 3.1.1

npm install -g vim-language-server

# Install font
brew tap epk/epk
brew install --cask font-sf-mono-nerd-font
