-- Script to trigger Flameshot to start GUI mode
-- This is because `flameshot gui` will fail to save to clipboard
-- See https://github.com/flameshot-org/flameshot/issues/3328

tell application "Flameshot"
    if not running then activate
end tell

tell application "System Events"
    tell process "Flameshot"
        click menu item "Take Screenshot" of menu 1 of menu bar item 1 of menu bar 2
    end tell
end tell

