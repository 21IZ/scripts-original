#!/bin/bash
#Quitar el encabezado del segundo grafico
cat CIDEM-501_Ac-Eukaryotic2_2.agr > CIDEM-501_Ac-Eukaryotic2_2.temp
sed -i "1,9d" CIDEM-501_Ac-Eukaryotic2_2.temp
#Borrar el & ultimo del 1er grafico
sed -e '$ d' CIDEM-501_Ac-Eukaryotic2.agr  > CIDEM-501_Ac-Eukaryotic2.temp
#saber el ultimo numero del eje x en el grafico 1 y almacenarlo en una variable
last_number=$(tail -n 1 CIDEM-501_Ac-Eukaryotic2.temp | awk '{print $1}')
#echo "el ultimo numero es: $last_number"
#Sumar el ultimo numero a la primera columna del grafico 2
awk '{print ($1 + "'$last_number'")" "$2}' CIDEM-501_Ac-Eukaryotic2_2.temp > CIDEM-501_Ac-Eukaryotic2_22.temp
#Borrar el ultimo numero del grafico 2 nuevo y cambiarlo por &
sed -e '$ d' CIDEM-501_Ac-Eukaryotic2_22.temp > CIDEM-501_Ac-Eukaryotic2_23.temp
sed -i '$a &' CIDEM-501_Ac-Eukaryotic2_23.temp
#Unir los graficos
cat CIDEM-501_Ac-Eukaryotic2.temp CIDEM-501_Ac-Eukaryotic2_23.temp > complete-CIDEM-501_Ac-Eukaryotic2-MEMB_interaction_surface.agr
#Borrar temporales
rm *.temp
