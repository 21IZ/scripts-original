package require membranethickness 1.1

########################## Compute a thickness map ######################################################
#"Usage: thicknessmap -structure file -trajectory file \[options\]
#Options:
#  [::membranetool_common::frame_arguments_help]
#  -sel <string> -- atoms to use to measure the thickness. Default: \"name P\"
#  -type up|down|total -- what to average: deformation of top/bottom layer, or thickness
#  -res 2.0      -- grid resolution
#  -wrapcmd  \{command\} -- a command that will be executed on each frame in order to wrap
#                   the system. Default: {pbc wrap -center bb -centersel membplugin_lipid
#                   -compound res -all}
#  -o <file>     -- output file path without extension. A tabulated file
#                   is generated.                          Default: thicknessmap.dat
#  -odx <file>   -- average thickness map in OpenDX fmt.   Default: thicknessmap.dx
#
#  Return value: { {x_matrix} {y_matrix} {result_average_matrix} }
#
#  NOTE: the output file contains all frames, in long format,
#        while the return value is averaged!"
###########################################################################################################

thicknessmap -structure ../../complex_wi.psf -trajectory ../../PBC_Wrap/P90_MEMBprod-3_wrap_500.dcd -sel "name P" -wrapcmd {pbc wrap -center bb -centersel membplugin_lipid -compound res -all} -from 0 -to 4999 -step 1 -res 2.0 -type total -o thicknessmap.dat -odx thicknessmap.dx

exit
