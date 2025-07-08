package require pbctools
package require bigdcd
proc myrmsd { frame } {
   global protein
   global dipoleout
   puts $dipoleout "$frame [measure dipole $protein]"
 }
set dipoleout [open "dipole_momentum_protein2.txt" w]

set mol [mol new ../complex_wi.psf type psf waitfor all]
set protein [atomselect top "protein and not resname YND"]
#puts $dipoleout "Frame    x      y        z"
bigdcd myrmsd dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_50.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_100.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_150.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_200.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_250.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_300.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_350.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_400.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_450.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_500.dcd
bigdcd_wait
quit
