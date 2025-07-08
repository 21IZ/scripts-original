#!/usr/bin/tclsh
package require pbctools

set a 50

#while loop execution
while { $a < 510} {
   mol new ../complex_wi.psf
   mol addfile ../P90_MEMBprod-3_$a.dcd waitfor all
   #pbc wrap -centersel "protein" -center com -compound residue -all
   pbc wrap -centersel "segname MEMB" -center com -compound residue -all
   animate write dcd P90_MEMBprod-3_wrap_$a.dcd
   mol delete all

   incr a 50
}

exit
