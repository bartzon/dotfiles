osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"~/code/dotfiles/macos/background.jpeg\" as POSIX file"

sh brew.sh
sh defaults.sh

pip3 install gcalendar

cd ../bin/agenda
bundle install
bundle exec whenever --update-crontab
cd -

cp ./'Monaco Nerd Font Complete Mono.otf' ~/Library/Fonts
cp ./'Monaco Nerd Font Complete.otf' ~/Library/Fonts

