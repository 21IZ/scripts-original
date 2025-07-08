package require bigdcd
package require pbctools
proc mysasa { frame } {
   global sel sellig selrec
   global sasaout
   set complex [measure sasa 1.4 $sel]
   set lig [measure sasa 1.4 $sellig]
   set rec [measure sasa 1.4 $selrec]
   puts $sasaout "$frame [expr {($lig + $rec - $complex) / 2}]"
 }

set mol [mol new ../complex_wi.psf type psf waitfor all]
set sel [atomselect $mol "segname MEMB or protein"]
set sellig [atomselect $mol "protein"]
set selrec [atomselect $mol "segname MEMB"]
mol addfile ../complex_wi.pdb waitfor all
set sasaout [open "CIDEM-501_Ac-G+_250ns-adelante.agr" w]
puts $sasaout "@type xy"
puts $sasaout "@title \"Interaction area\""
puts $sasaout "@s1 legend \"CIDEM-501_Ac-G+\""
puts $sasaout "@xaxis label \"Frames (ns)\""
puts $sasaout "@yaxis label \"Interaction area (A)\""
puts $sasaout "0 0\n&\n0 0.0\n"
bigdcd mysasa dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_250.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_300.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_350.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_400.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_450.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_500.dcd
bigdcd_wait
puts $sasaout "&"
close $sasaout
exit
