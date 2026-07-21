# fukui-snapshots.cmd -- save the current view, rotate, save again
# Chiara Picarelli / utils
#
# Run AFTER opening the structure (.fchk) + the .cube and applying the style:
#     open neutral.fchk
#     open my-fukui.cube
#     read fukui-style.cmd
#     read fukui-snapshots.cmd
#
# Produces two PNGs from the current framing. Rename the output files (or add a
# path) per molecule so successive runs don't overwrite each other. Scale is
# kept identical between the two views (no re-focus after the turn).
#
# IMPORTANT: Chimera forces the saved image to the graphics-window aspect ratio,
# so `width`/`height` that don't match the window get overridden to the window
# size. We set the window aspect first with `windowsize`, matching the 3:2 of
# the 2400x1600 output below. For a wide 2:1 image instead, use
# `windowsize 1600 800` and `... width 2400 height 1200`.

# set a 3:2 window (kept small so it fits any screen; supersample gives the res)
windowsize 1200 800
# reframe once for the new aspect; not repeated after the turn, so both views
# keep the same scale
focus

# front view
copy file fukui_front.png png width 2400 height 1600 supersample 3

# rotate 90 deg about the vertical (y) axis, then save again
turn y 90
copy file fukui_y90.png png width 2400 height 1600 supersample 3
