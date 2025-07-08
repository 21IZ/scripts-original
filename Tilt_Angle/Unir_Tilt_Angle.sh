echo "Uniendo las graficas"

cnt=50
cntmax=100

while [ $cnt -le $cntmax ]
do
    awk '{print $2}' tilt_angle_${cnt}.dat

    cnt=$(expr $cnt + 50)

done > tilt_angle_100ns.agr
