# Chiara Picarelli, DCMC - Politecnico di Milano
# chiara.picarelli@polimi.it
# https://github.com/cippee/utils
# May 2024
#
# orbital-style.cmd -- Chimera preset: molecule + signed volume surface
#                      (orbital / Fukui red/blue lobes)
#
# Same look as molecule-style.cmd, plus a signed volume surface.
# Apply with:  read orbital-style.cmd

# --- display style ---------------------------------------------------------
represent b+s
color byelement

# hide dashed pseudobonds that can poke through the surface
setattr g display false

# --- silhouette edging -----------------------------------------------------
# outline thickness (px); lower for thinner lines
set silhouetteWidth 3.5
set silhouetteColor black
set silhouette

# --- depth cueing ----------------------------------------------------------
# Original values. Do NOT add `set depthCue` or clamp dcEnd to 1.0: forcing the
# fog on darkens the whole scene and the white hydrogens stop reading.
set dcColor black
set dcStart 0.5
set dcEnd 1.5

# --- lighting (modelled three-point, slightly glossy) ----------------------
lighting mode two-point
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

turn x 90

# --- to save an image, uncomment (supersample = anti-aliasing) -------------
# copy file newframe.png png supersample 3
