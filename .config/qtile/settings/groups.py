# Qtile workspaces

from libqtile.config import Key, Group
from libqtile.command import lazy
from .keys import mod, keys


# Get the icons at https://www.nerdfonts.com/cheat-sheet (you need a Nerd Font)
# Icons: 
# nf-linux-archlinux
# nf-oct-terminal
# nf-oct-browser
# nf-oct-search
# nf-cod-file_submodule
# nf-cod-checklist
# nf-mdi-music_box_outline
# nf-mdi-message_outline
# nf-cod-layers

groups = [Group(i) for i in ["   ", " 󰨞  ", "   ", "   ", "   ", "   ", "   ", "   ", "   "]]

for i, group in enumerate(groups):
    actual_key = str(i + 1)
    keys.extend([
        # Switch to workspace N
        Key([mod], actual_key, lazy.group[group.name].toscreen()),
        # Send window to workspace N
        Key([mod, "shift"], actual_key, lazy.window.togroup(group.name))
    ])
