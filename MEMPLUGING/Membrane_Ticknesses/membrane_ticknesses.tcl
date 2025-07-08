package require membranethickness 1.1

######################## Calcular average del grosor de la Mebrana ####################################
#Options:
#  [::membranetool_common::frame_arguments_help]
#  -sel <string> -- atoms to use to measure the thickness. Default: \"name P\"
#  -wrapcmd  \{command\} -- a command that will be executed on each frame in order to wrap
#                   the system. Default: {pbc wrap -center bb -centersel membplugin_lipid
#                   -compound res -all}
#  -o <file>     -- output file path without extension. A tabulated file
#                   is generated. Default: membranethickness.out
########################################################################################################

#mol load psf ../../step5_assembly.psf
#mol addfile dcd ../../PBC_Wrap/P90_MEMBprod-3_wrap_500.dcd waitfor all

membranethickness -structure ../../complex_wi.psf -trajectory ../../PBC_Wrap/P90_MEMBprod-3_wrap_500.dcd -sel "name P" -wrapcmd {pbc wrap -center bb -centersel membplugin_lipid -compound res -all} -from 0 -to 4999 -step 1 -o membranethickness.out

exit
