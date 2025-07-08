#!/bin/bash -x

echo '#         X        Y       Z      X/Y     R       Z/R     ' > polar2.dat
awk '{print $0, " ", $2/$3, " ", sqrt(($2)^2 + ($3)^2 + ($4)^2), $4/(sqrt(($2)^2 + ($3)^2 + ($4)^2)) }' dipole_momentum_protein2.txt >> polar2.dat

exit
