#!/bin/bash

gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Control>Shift_L', '<Shift>Control_L', 'XF86Keyboard']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Alt>Shift_L', '<Shift>Alt_L', '<Shift>XF86Keyboard']"

echo -e "Result:\n"
gsettings get org.gnome.desktop.wm.keybindings switch-input-source
gsettings get org.gnome.desktop.wm.keybindings switch-input-source-backward

exit 0 # Success
