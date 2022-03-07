#!/bin/zsh

tm_date="#[fg=#d79921,bg=black]$lglyph#[fg=black,bg=#d79921] %a, %d %b %Y - %H:%M "

if [[ `uname` == "Darwin" ]]; then
  tm_battery="#[fg=white,bg=black]#(~/.bin/battery_status.rb) "
  tm_next_meeting="#[fg=#427b58,bg=black]$lglyph#[bg=#427b58,fg=black] #(cat /tmp/next_calendar_meeting_parsed) #[fg=black,bg=#427b58]$lglyph"
  tm_spotify="#[fg=#8ec07c,bg=black]$lglyph#[bg=#8ec07c,fg=black] #(osascript ~/.bin/get_track.applescript) #[fg=black,bg=#8ec07c]$lglyph"

  ri_status="$tm_battery$tm_next_meeting$tm_spotify$tm_date"
fi

if [[ `uname` == "Linux" ]]; then
  ri_status="$tm_date"
fi

tmux set -g status-right="$ri_status"
