#!/bin/bash -xe

last_frame=$(tail -n 1 *.dat | awk '{print $1}')

echo "Obteniendo Frame ${last_frame}"
############ Sacar los valores del frame_4999 para obtener el GridX y GridY ################################
cat *.dat | grep ${last_frame} > frame_${last_frame}.temp
#Transformar a csv
GridX=$(awk '{print $2}' frame_${last_frame}.temp)
GridY=$(awk '{print $3}' frame_${last_frame}.temp)
echo $GridX > GridX.temp
echo $GridY > GridY.temp
###########################################################################################################

echo "Corriendo dx2csv.sh"
############ Transformar dx a csv dx2csv.sh #################################################################
#seleccionar las columnas con los valores en el dx
sed -n '9,1988p' *.dx > valores.thicknessmap.temp

#Convertirlos en una sola columnas
tr ' ' '\n' < valores.thicknessmap.temp > valores_columna.thicknessmap.temp
#Quedarme solo con los valores numericos
awk '{for(i=1;i<=NF;i++) if($i ~ /^[0-9]*(\.[0-9]+)?$/) print $i}' valores_columna.thicknessmap.temp > valores_numericos.thicknessmap.temp

#Seleccionar un valor si y uno no
Zmeasure=$(sed -n 'p;n' valores_numericos.thicknessmap.temp)
####################################################################################################################

paste -d " " <(echo "${GridX}") <(echo "${GridY}") <(echo "${Zmeasure}") > thicknessmap.temp

max_value=$(awk '{print $3}' thicknessmap.temp | sort | tail -n 1)

awk -v max="${max_value}" '{$3 = $3 - max; print}' thicknessmap.temp | head -n -1 > thicknessmap2.temp

#darle los espacios para que el gnuplot 3D lo reconozca cuando cambia el numero de la primera columna pone un espacio debajo
awk -f addblanks.awk thicknessmap.temp > thicknessmap_matrix.dat
awk -f addblanks.awk thicknessmap2.temp > DDthicknessmap_matrix.dat
#Quitar los temporales
rm *.temp


