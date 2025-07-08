#!/bin/bash

cnt=50
cntmax=500

while [ $cnt -le $cntmax ]
do

    echo "PROCESANDO DCD ${cnt}"

    python3 dssp.py -top ../complex_wi.psf -traj ../P90_MEMBprod-3_${cnt}.dcd -odir ./P90_MEMBprod-3_${cnt}_dssp_outputs

    cnt=$(expr $cnt + 50)

done

#Unificar los analisis en un solo fichero

echo "Coil,Beta,Helix" > ./secondary_structure_analysis.csv

cnt=50
cntmax=500

while [ $cnt -le $cntmax ]
do
    echo "PROCESANDO output ${cnt}"

    awk 'NR>=2 && NR<=5001 {print $2 "," $3 "," $4}' ./P90_MEMBprod-3_${cnt}_dssp_outputs/*_reduced.log >> ./secondary_structure_analysis.csv

   cnt=$(expr $cnt + 50)

done
