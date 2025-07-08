#! /bin/bash

cnt=50
cntmax=500

while [ $cnt -le $cntmax ]
do
    echo "############# P90_MEMBprod-3_${cnt}.dcd #############################"

######Crear script para VMD ############
cat <<EOFK >peptide_tilt_angle.tcl

##########CALCULATE Angle of TM helix of Protein ######
set output_TM [open "tilt_angle_${cnt}.dat" w]
mol new ../complex_wi.psf
mol addfile ../P90_MEMBprod-3_${cnt}.dcd type dcd waitfor all
set numframes [molinfo 0 get numframes]
for {set frame 0} {\$frame < \$numframes} {incr frame} {
set p_TM1 [atomselect 0 "protein and resid 13 to 16" frame \$frame]
set c_TM1 [measure center \$p_TM1 weight mass]
set p_TM2 [atomselect 0 "protein and resname CYS" frame \$frame]
set c_TM2 [measure center \$p_TM2 weight mass]
set ax_TM [vecsub \$c_TM2 \$c_TM1]
set lax_TM [veclength \$ax_TM]
set k "0 0 1"
set dot_TM [vecdot \$ax_TM \$k]
set cos_TM [expr "\$dot_TM / \$lax_TM"]
set ang_rad_TM [tcl::mathfunc::acos "\$cos_TM"]
set ang_deg_TM [expr "57.2957795 * \$ang_rad_TM"]
puts \$output_TM "\$frame \$ang_deg_TM"
\$p_TM1 delete
\$p_TM2 delete
}
quit
EOFK
###########################################################

vmd -dispdev text -e peptide_tilt_angle.tcl

    cnt=$(expr $cnt + 50)
done

## Analizar las producciones wrapeadas
#
#cnt=50
#cntmax=450
#
#while [ $cnt -le $cntmax ]
#do
#    echo "P90_MEMBprod-3_${cnt}.dcd"
#
#######Crear script para VMD ############
#cat <<EOFK >peptide_tilt_angle.tcl
#
###########CALCULATE Angle of TM helix of Protein ######
#set output_TM [open "tilt_angle_${cnt}.dat" w]
#mol new ../complex_wi.psf
#mol addfile ../PBC_Wrap/P90_MEMBprod-3_wrap_$cnt.dcd type dcd waitfor all
#set numframes [molinfo 0 get numframes]
#for {set frame 0} {$frame < $numframes} {incr frame} {
#set p_TM1 [atomselect 0 "protein and resid 13 to 16" frame $frame]
#set c_TM1 [measure center $p_TM1 weight mass]
#set p_TM2 [atomselect 0 "protein and resname CYS" frame $frame]
#set c_TM2 [measure center $p_TM2 weight mass]
#set ax_TM [vecsub $c_TM2 $c_TM1]
#set lax_TM [veclength $ax_TM]
#set k "0 0 1"
#set dot_TM [vecdot $ax_TM $k]
#set cos_TM [expr "$dot_TM / $lax_TM"]
#set ang_rad_TM [tcl::mathfunc::acos "$cos_TM"]
#set ang_deg_TM [expr "57.2957795 * $ang_rad_TM"]
#puts $output_TM "$frame $ang_deg_TM"
#$p_TM1 delete
#$p_TM2 delete
#}
#quit
#EOFK
############################################################
#
#vmd -dispdev text -e areaperlipid.tcl
#
#    cnt=$(expr $cnt + 50)
#done

echo "Uniendo las graficas"

cnt=50
cntmax=500

while [ $cnt -le $cntmax ]
do
    awk '{print $2}' tilt_angle_${cnt}.dat

    cnt=$(expr $cnt + 50)

done > tilt_angle_completo.agr
