package require membranescd 1.1

########################## Compute a thickness map ######################################################
#"Usage: membranescd -structure file -trajectory file \[options\]"
#"Arguments:"
#"  -sel \"atomselection\" -- atom selection to be analysed (string)."
#"                   Default: not resname CHL1"
#"  -lipid \"resname1 resname2 ...\" -- list of lipid resnames."
#"                   Default: \$lipids in config.tcl file."
# "  -chainids {{\"chain2_identifier\" \"starting_index2\"} {\"chain3_identifier\""
# " \"starting_index3\"}}  -- set identifiers for phospho/sphingolipid chains"
# "                   and the starting index for carbon atoms in each chain."
# "                   Default: {2 3}"
#"  -chain {1 2 3}  -- acyl chains to be analysed (list)."
#"                   Default: {1 2 3}"
#"  -leaf {0 1}   -- membrane leaflets to be analysed (list)."
#"                   Default: {0 1}"
#"  -from <frame> -- init frame (integer or string). Default: 0"
#"  -to <frame>   -- last frame (integer or string). Default: {last}"
#"  -step <int>   -- frame step (integer). Default: 1"
# "Other options:"
# "  -wrapcmd  {command} -- command executed to wrap system up (string)."
# "                   Default: {pbc wrap -center bb -centersel membplugin_lipid"
# "                   -compound res -all}"
# "  -o <file>     -- path to output file (string)."
# "                   Default file path: loaded trajectory."
# "                   Default file extension: \".orderparSCD"
###########################################################################################################

membranescd -structure ./complex_wi.psf -trajectory ./P90_MEMBprod-3_wrap_500.dcd -lipid {DOPG TMCL2} -chain {2 3} -leaf {0 1} -from 0 -to 4999 -step 1 -wrapcmd {pbc wrap -center bb -centersel membplugin_lipid -compound res -all} -o membranescd.orderparSCD

exit
