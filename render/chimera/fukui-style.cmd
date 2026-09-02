# Chiara Picarelli, DCMC - Politecnico di Milano
# chiara.picarelli@polimi.it
# https://github.com/cippee/utils
# July 2026
#
# fukui-style.cmd -- Chimera render preset for Fukui / orbital cubes
#
# Applies the full look (ball-and-stick molecule + signed isosurfaces) to an
# open structure + cube. Chimera reads only the VOLUME from a .cube (it ignores
# the atoms), so open the matching .fchk first to get the molecule:
#     open neutral.fchk        <- atoms (from the checkpoint used to make the cube)
#     open my-fukui.cube       <- volume
#     read fukui-style.cmd     <- this file
# Then save/rotate with fukui-snapshots.cmd.
#
# Standalone: it does NOT modify molecule-style.cmd / orbital-style.cmd. The
# only real change vs orbital-style.cmd is the isosurface level: 0.02 suits MO
# cubes but is too high for these Fukui difference densities (they peak
# ~0.02-0.04, so 0.02 shows almost nothing) -- 0.004 renders proper lobes.

# --- molecule --------------------------------------------------------------
represent b+s
color byelement
# hide dashed pseudobonds
setattr g display false

# --- silhouette edging -----------------------------------------------------
set silhouetteWidth 3.5
set silhouetteColor black
set silhouette

# --- depth cueing ----------------------------------------------------------
# Original values. Do NOT add `set depthCue` or clamp dcEnd to 1.0: forcing the
# fog on darkens the whole scene and the white hydrogens stop reading.
set dcColor black
set dcStart 0.5
set dcEnd 1.5

# --- lighting (three-point, slightly glossy) -------------------------------
lighting mode two-point
lighting mode three-point
lighting brightness 0.85
lighting contrast 0.85
lighting ratio 4.0
lighting sharpness 128.0
lighting reflectivity 0.5

# --- background ------------------------------------------------------------
set bgTransparency

# --- volume: full-res signed isosurface, positive red / negative blue ------
volume all step 1
volume all style surface level 0.004 color 1.000,0.077,0.115,0.8 level -0.004 color 0.308,0.462,1.000,0.8

# frame it
focus

# --- to save, uncomment (supersample = anti-aliasing) ----------------------
# copy file fukui.png png width 2400 height 1600 supersample 3
