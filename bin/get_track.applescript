tell application "Spotify"
	set a to artist of current track as string
	set t to name of current track as string

	if (player state of application "Spotify" is playing) then
		set s to "▶ "
    return s & a & " - " & t
	else
		set s to ""
    return
	end if
end tell
