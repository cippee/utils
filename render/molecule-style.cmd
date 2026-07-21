# Chimera command preset -- molecules (ball-and-stick, silhouettes, 3-point light)
# Chiara Picarelli, PoliMI, May 2024
# molecule-style.cmd
#
# Apply with:  read molecule-style.cmd

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

# frame the molecule
focus

# --- to save an image, uncomment (supersample = anti-aliasing) -------------
# copy file newframe.png png supersample 3
