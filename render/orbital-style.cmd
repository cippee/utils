# Chimera command preset -- orbitals / Fukui volumes (signed red/blue lobes)
# Chiara Picarelli, PoliMI, May 2024
# orbital-style.cmd
#
# Same look as molecule-style.cmd, plus a signed volume surface.
# Apply with:  read orbital-style.cmd

# --- display style ---------------------------------------------------------
represent b+s
color byelement

# hide dashed pseudobonds that can poke through the surface
setattr g display false

# --- silhouette edging -----------------------------------------------------
set silhouetteWidth 3.5        # outline thickness (px); lower for thinner lines
set silhouetteColor black
set silhouette

# --- depth cueing ----------------------------------------------------------
# NB: dcStart/dcEnd are fractions in [0,1]; the old dcEnd 1.5 was out of range
# and silently ignored. Enable depth cue explicitly and keep end <= 1.0.
set depthCue
set dcColor black
set dcStart 0.5
set dcEnd 1.0

# --- lighting (modelled three-point, slightly glossy) ----------------------
lighting mode three-point
lighting brightness 0.85
lighting contrast 0.85
lighting ratio 4.0
lighting sharpness 128.0
lighting reflectivity 0.5

# --- background ------------------------------------------------------------
set bgTransparency

# --- volume: signed isosurface, positive red / negative blue (alpha 0.8) ---
# 'step 1' forces full-resolution rendering: on large cubes Chimera downsamples
# by default, which gives blocky lobes. Remove it if rendering feels sluggish.
volume all step 1
volume all style surface level 0.02 color 1.000,0.077,0.115,0.8 level -0.02 color 0.308,0.462,1.000,0.8

# alternative pastel pair (uncomment to use instead of the line above):
# volume all style surface level 0.02 color 0.776,0.796,0.929,0.8 level -0.02 color 0.945,0.996,0.875,0.8

# frame the molecule
focus

# --- to save an image, uncomment (supersample = anti-aliasing) -------------
# copy file newframe.png png supersample 3
