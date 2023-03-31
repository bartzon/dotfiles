#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Copy Chrome URL
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Copy current page URL from Chrome

osascript -e 'tell application "Google Chrome" to get URL of active tab of first window' | pbcopy
echo "Copied"
