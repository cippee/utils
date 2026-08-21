# Chiara Picarelli, DCMC - Politecnico di Milano
# chiara.picarelli@polimi.it
# https://github.com/cippee/utils
# May 2024
#
# molecule-style.cmd -- Chimera preset: ball-and-stick molecule
#                       (silhouettes, three-point lighting)
#
# Apply with:  read molecule-style.cmd

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

# frame the molecule
focus

# --- to save an image, uncomment (supersample = anti-aliasing) -------------
# copy file newframe.png png supersample 3
