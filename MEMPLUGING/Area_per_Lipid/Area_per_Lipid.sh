#! /bin/bash

cnt=1
cntmax=2

while [ $cnt -le $cntmax ]
do

echo "P90_MEMBmineq-${cnt}.dcd"

######Crear script para VMD que genere los ficheros con los COM de membrana y proteina ############
cat <<EOFK >areaperlipid.tcl

package require lipidarea 1.1


################################# Area per lipid ########################################################################
#Usage: membranescd -structure file -trajectory file \[options\]"
#Arguments:"
#  -triatom {{\"resnames\" {atom1 \[atom2 atom 3\]}} ... }"
#                -- resname and corresponding atom triad or single atom (list)."
#                   Default {{\"DPPC DSPC DOPC SDPC\" \"C2 C21 C31\"} {\"SM18\" \"C2 C21 C3\"} {\"CHL1\" \"C13 C10\"}}"
#  -nodefaults   -- ignore the default resnames and atom triads"
#  -leaf {0 1}   -- membrane leaflets to be analysed (list)."
#                   Default: {0 1}"
#  -from <frame> -- init frame (integer or string). Default: 0"
#  -to <frame>   -- last frame (integer or string). Default: {last}"
#  -step <int>   -- frame step (integer). Default: 1"
#Other options:"
#  -wrapcmd  {command} -- a command that will be executed on each frame in order to wrap"
#                   the system. Default: {pbc wrap -center bb -centersel membplugin_lipid"
#                   -compound res -all}"
#  -qvoronoi  <path> -- path to the qvoronoi binary. If empty, the path in"
#                   config.tcl will be used."
#  -o <file>     -- path to output file (string)."
#                   Default file path: loaded trajectory."
#                   Default file extensions: \"_average.area\" and \"_total.area\""
##########################################################################################################################

lipidarea -structure {../../step5_assembly.psf} -trajectory {../../P90_MEMBmineq-${cnt}.dcd} -triatom {{"DOPG DOPE" "C2 C21 C31"} {"TMCL2" "C2 C12 C32"}} -leaf {1} -from {0} -to {last} -step {1} -qvoronoi {/usr/local/lib/vmd/plugins/noarch/tcl/membplugin1.1/binaries/LINUX/qvoronoi} -o {P90_MEMBmineq-${cnt}} -wrapcmd {pbc wrap -center bb -centersel membplugin_lipid -compound res}

exit

EOFK
#####################################################################################################

vmd -dispdev text -e areaperlipid.tcl

    cnt=$(expr $cnt + 1)
done

## Analizar las producciones
#cnt=50
#cntmax=250
#
#while [ $cnt -le $cntmax ]
#do
#    echo "P90_MEMBprod-3_${cnt}.dcd"
#
#######Crear script para VMD que genere los ficheros con los COM de membrana y proteina ############
#cat <<EOFK >areaperlipid.tcl

#package require lipidarea 1.1


################################# Area per lipid ########################################################################
#Usage: membranescd -structure file -trajectory file \[options\]"
#Arguments:"
#  -triatom {{\"resnames\" {atom1 \[atom2 atom 3\]}} ... }"
#                -- resname and corresponding atom triad or single atom (list)."
#                   Default {{\"DPPC DSPC DOPC SDPC\" \"C2 C21 C31\"} {\"SM18\" \"C2 C21 C3\"} {\"CHL1\" \"C13 C10\"}}"
#  -nodefaults   -- ignore the default resnames and atom triads"
#  -leaf {0 1}   -- membrane leaflets to be analysed (list)."
#                   Default: {0 1}"
#  -from <frame> -- init frame (integer or string). Default: 0"
#  -to <frame>   -- last frame (integer or string). Default: {last}"
#  -step <int>   -- frame step (integer). Default: 1"
#Other options:"
#  -wrapcmd  {command} -- a command that will be executed on each frame in order to wrap"
#                   the system. Default: {pbc wrap -center bb -centersel membplugin_lipid"
#                   -compound res -all}"
#  -qvoronoi  <path> -- path to the qvoronoi binary. If empty, the path in"
#                   config.tcl will be used."
#  -o <file>     -- path to output file (string)."
#                   Default file path: loaded trajectory."
#                   Default file extensions: \"_average.area\" and \"_total.area\""
##########################################################################################################################

#lipidarea -structure {../../step5_assembly.psf} -trajectory {../../P90_MEMBprod-3_${cnt}.dcd} -triatom {{"DOPG DOPE" "C2 C21 C31"} {"TMCL2" "C2 C12 C32"}} -leaf {1} -from {0} -to {last} -step {1} -qvoronoi {/usr/local/lib/vmd/plugins/noarch/tcl/membplugin1.1/binaries/LINUX/qvoronoi} -o {P90_MEMBprod-3_${cnt}} -wrapcmd {pbc wrap -center bb -centersel membplugin_lipid -compound res}
#
#exit
#
#EOFK
#####################################################################################################
#
#vmd -dispdev text -e areaperlipid.tcl
#
#    cnt=$(expr $cnt + 50)
#done

# Analizar las producciones wrapeadas
cnt=50
cntmax=500

while [ $cnt -le $cntmax ]
do
    echo "P90_MEMBprod-3_${cnt}.dcd"

######Crear script para VMD que genere los ficheros con los COM de membrana y proteina ############
cat <<EOFK >areaperlipid.tcl

package require lipidarea 1.1


################################# Area per lipid ########################################################################
#Usage: membranescd -structure file -trajectory file \[options\]"
#Arguments:"
#  -triatom {{\"resnames\" {atom1 \[atom2 atom 3\]}} ... }"
#                -- resname and corresponding atom triad or single atom (list)."
#                   Default {{\"DPPC DSPC DOPC SDPC\" \"C2 C21 C31\"} {\"SM18\" \"C2 C21 C3\"} {\"CHL1\" \"C13 C10\"}}"
#  -nodefaults   -- ignore the default resnames and atom triads"
#  -leaf {0 1}   -- membrane leaflets to be analysed (list)."
#                   Default: {0 1}"
#  -from <frame> -- init frame (integer or string). Default: 0"
#  -to <frame>   -- last frame (integer or string). Default: {last}"
#  -step <int>   -- frame step (integer). Default: 1"
#Other options:"
#  -wrapcmd  {command} -- a command that will be executed on each frame in order to wrap"
#                   the system. Default: {pbc wrap -center bb -centersel membplugin_lipid"
#                   -compound res -all}"
#  -qvoronoi  <path> -- path to the qvoronoi binary. If empty, the path in"
#                   config.tcl will be used."
#  -o <file>     -- path to output file (string)."
#                   Default file path: loaded trajectory."
#                   Default file extensions: \"_average.area\" and \"_total.area\""
##########################################################################################################################

lipidarea -structure {../../complex_wi.psf} -trajectory {../../PBC_Wrap/P90_MEMBprod-3_wrap_${cnt}.dcd} -triatom {{"DOPG DOPE" "C2 C21 C31"} {"TMCL2" "C2 C12 C32"}} -leaf {1} -from {0} -to {last} -step {1} -qvoronoi {/usr/local/lib/vmd/plugins/noarch/tcl/membplugin1.1/binaries/LINUX/qvoronoi} -o {P90_MEMBprod-3_${cnt}} -wrapcmd {pbc wrap -center bb -centersel membplugin_lipid -compound res}

exit

EOFK
####################################################################################################

vmd -dispdev text -e areaperlipid.tcl

    cnt=$(expr $cnt + 50)
done
