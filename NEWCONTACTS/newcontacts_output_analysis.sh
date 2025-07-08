#!/bin/bash
#La diferencia de este script con el de puentes de hydrogenos viene dada por dos cosas, la primera es que hay que cambiar la forma en la que se da el fichero de secuencia que va primero el numero_espacio_aminoacido. Segundo, hay que agregar un comando extra para arreglar la numeracion de los aas ya que en la salida del script tiene un valor menos.
#Crea un directorio donde se van a colocar los ficheros de salida

mkdir output

#Remplaza la columna 4 de sort_contact_AB que esta 1 valor menor con la columna 9 de #sort_contact_AB_renumber que tiene los valores correctos y la salida la envia a un nuevo fichero.
#Explicación del código:
#    FNR==NR todo le permite trabajar con un archivo completo a la vez. En este caso, es el archivo sort_contact_AB_renumber.dat. NR y FNR ambos contienen números de línea con la diferencia FNR se restablece a 1 cuando se lee un archivo nuevo donde NR continúa incrementándose.
#    Mientras que estamos trabajando con sort_contact_AB_renumber.dat archivo, estamos creando una matriz llamada a utilizando número de línea (NR) como la columna key y tercero ($3) como el valor. next nos permite omitir el resto del bloque de acción.
#    Una vez que finaliza el archivo sort_contact_AB_renumber.dat, comenzamos a trabajar en el archivo sort_contact_AB.dat. NR==FNR condición no se convertirá en falso ya que FNR aumentará desde 1 y NR no lo hará. Por lo tanto, solo se trabajará en el segundo bloque de acción {$2=a[FNR]}.
#    Lo que hace este bloque es reasignar el valor de la segunda columna al valor de la matriz al buscar el número de la línea.
#    1 al final imprime la línea. Devuelve verdadero, y en awk declaraciones verdaderas resulta en la impresión de la línea.
#    sort_contact_AB_renumber.dat sort_contact_AB.dat es el orden de los archivos definidos. Como queremos crear una matriz a partir del archivo sort_contact_AB_renumber.dat, la ponemos primero.

awk 'FNR==NR{a[NR]=$9;next}{$4=a[FNR]}1' ../sort_contact_AB_renumber.dat ../sort_contact_AB.dat > sort_contact_AB_final.out

#genera la variable secuenca para tener los aas
secuencia=$(while IFS= read -r aas; do echo $aas; done < ../P90_acilado_secuencia.txt)

#Este loop es el que extrae las interacciones para cada aas y hace la suma (sum) para obtener el total
while IFS= read -r aas
do
  interacciones=$(echo "${aas}"; grep "${aas}" sort_contact_AB_final.out | awk '{sum+=$7 ; print $0} END{print "sum=",sum}')
  echo "${interacciones}" 
done < ../P90_acilado_secuencia.txt > interacciones_ordenadas.out

#genera una variable donde se almacena la sumatoria de interacciones para cada aas
total_interacciones=$(cat interacciones_ordenadas.out | grep sum | awk '{print $2}')

#genera un fichero solo con los aas
echo "${secuencia}" > secuencia.out

#genera un fichero solo con las ocupancias
echo "${total_interacciones}" > ocupancia.out

#genera la salida en columnas aas=%ocupancia
paste -d"=" <(echo "${secuencia}") <(echo "${total_interacciones}") > total_interacciones.temp

#pone el encabezado en la primera linea de "aas %ocupancia"
sed '1s/^/aas %ocupancia\n/' total_interacciones.temp > total_interacciones.out

#mueve todos los ficheros de salida "*.out" para la carpeta output
rm *.temp
mv *.out ./output
