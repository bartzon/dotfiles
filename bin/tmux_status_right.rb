parts = [
  `~/.bin/battery_status.rb`,
  `cat /tmp/next_calendar_meeting_parsed`,
  `osascript ~/.bin/get_track.applescript`,
  `TZ='Europe/Amsterdam' date +'%a, %e, %b %Y - %H:%M'`.gsub('  ', ' ')
]

puts parts
  .map(&:chomp)
  .reject(&:empty?)
  .compact
  .join('  |  ')
