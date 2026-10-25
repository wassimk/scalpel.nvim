# README demo for scalpel.nvim
#
# Render from the repo root:
#   vhs demo/scalpel.tape
#
# Edits a temp copy of lua/scalpel/init.lua, so the repo is never modified.

Output scalpel.gif

Require nvim
Require git
Require bash

Set Shell "bash"
Set FontFamily "MonoLisaCode, JetBrainsMono Nerd Font"
Set FontSize 16
Set Width 1000
Set Height 640
Set Padding 16
Set Theme "OneHalfDark"
Set TypingSpeed 120ms
Set CursorBlink false

# Setup: temp copy of the plugin source, open it in nvim with the minimal config
Hide
Type "export SCALPEL_DIR=$PWD DEMO_INIT=$PWD/demo/init.lua"
Enter
Type "rm -rf /tmp/scalpel-demo && mkdir -p /tmp/scalpel-demo/lua/scalpel && cp lua/scalpel/init.lua /tmp/scalpel-demo/lua/scalpel/"
Enter
Type "cd /tmp/scalpel-demo && nvim -u $DEMO_INIT lua/scalpel/init.lua"
Enter
Wait+Screen /local M = \{\}/
Sleep 500ms
Show

Sleep 1s

# Walk down to `local function get_visual()`
Down@200ms 10
Sleep 400ms

# Jump to the function name and trigger scalpel (<leader>e)
Type "fg"
Sleep 600ms
Space
Type "e"
Wait+Screen /:%s\/\\vget_visual\/\/gc/
Sleep 1s

# Type the replacement and confirm both matches
Type "get_visual_range"
Sleep 600ms
Enter
Wait+Screen /replace with get_visual_range/
Sleep 800ms
Type "y"
Sleep 800ms
Type "y"

# Hold on the result before looping
Sleep 3s
