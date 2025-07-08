#!/usr/bin/tclsh

set a 50

#while loop execution
while { $a < 510 } {
   
   mol new ../complex_wi.psf
   mol addfile ../PBC_Wrap/P90_MEMBprod-3_wrap_$a.dcd waitfor all
   set sel [atomselect top "all"]
   animate write pdb P90_MEMBprod-3_$a.pdb beg 4999 end 4999 sel $sel
   mol delete all
   
   incr a 50
}
   
exit
