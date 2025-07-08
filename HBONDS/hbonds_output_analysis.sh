#!/bin/bash
#En este script es necesrio darle un fichero que contenga los aas que quieres buscar en el fichero de interacciones
#Crea un directorio donde se van a colocar los ficheros de salida
mkdir output
#genera la variable secuenca para tener los aas
secuencia=$(while IFS= read -r aas; do echo $aas; done < P90_acilado_secuencia.txt)

#Este loop es el que extrae las interacciones para cada aas y hace la suma (sum) para obtener el total
while IFS= read -r aas
do
  interacciones=$(echo $aas; cat ./*-detailed.dat | grep $aas | awk '{sum+=$3 ; print $0} END{print "sum=",sum}')
  echo "${interacciones}" 
done < P90_acilado_secuencia.txt > interacciones_ordenadas.out

#genera una variable donde se almacena la sumatoria de interacciones para cada aas
total_interacciones=$(cat interacciones_ordenadas.out | grep sum | awk '{print $2}')

#genera un fichero solo con los aas
echo "${secuencia}" > secuencia.out
#genera un fichero solo con las ocupancias
echo "${total_interacciones}" > ocupancia.out
#genera la salida en columnas aas=%ocupancia
paste -d"=" <(echo "${secuencia}") <(echo "${total_interacciones}") > total_interacciones.temp

#Debido a que algunos aas se usaron con un "-" al final para facilitar el grep este comando lo elimina
sed "s/-//g" total_interacciones.temp > total_interacciones.out
#pone el encabezado en la primera linea de "aas %ocupancia"
sed -i '1s/^/aas %ocupancia\
/' total_interacciones.out
#elimina el temporal que se genera
rm *.temp
#mueve todos los ficheros de salida "*.out" para la carpeta output
mv *.out ./output
