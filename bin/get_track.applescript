tell application "Spotify"
	set a to artist of current track as string
	set t to name of current track as string

	if (player state of application "Spotify" is playing) then
		set s to "▶ "
	else
		set s to ""
	end if

	return s & a & " - " & t
end tell
