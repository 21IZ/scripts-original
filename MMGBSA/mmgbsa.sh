#! /bin/bash
############################################### MMGBSA #############################################################
#Este script calclula la enrgia de union mediante el metodo MMGBSA. Se coloca el script en una carpeta que         #
#contenga otras tres carpetas denominadas "complex", "membrane" y "protein". Dentro de cada una de estas carpetas  #
#hay que colocar el psf correspondiente al complejo, receptor y proteina, sin aguas y el fichero conf *_mmgbsa.conf#
#Una vez que tengas todo esto listo solo modifica los parametros que desees en el script y este te devolvera       #
#graficos de energia potencial de cada uno contra frames y un fichero con los valores de energia potencial, los    #
#promedios y el valor final de deltaG. Ademas de que va a imprimir en la consola estos ultimos. ENJOY              #
####################################################################################################################

psfinput=../complex_wi.psf
dcdinput=../PBC_Wrap/P90_MEMBprod-3_wrap_500.dcd
inicio=$(date)

######Crear script para VMD que genere los ficheros pdb y dcd del complejo, receptor y ligando sin aguas ############
cat <<EOFK >mmgbsa.tcl
package require pbctools
mol new "${psfinput}"
mol addfile "${dcdinput}" waitfor all
set complex [atomselect top "not chain W I"]
set membrane [atomselect top "segname MEMB"]
set ligand [atomselect top "protein"]
animate write pdb ./complex/complejo_vacio_500.pdb beg 1 end 1 sel \$complex
animate write dcd ./complex/complejo_vacio_500.dcd sel \$complex
animate write pdb ./membrane/membrana_vacio_500.pdb beg 1 end 1 sel \$membrane
animate write dcd ./membrane/membrana_vacio_500.dcd sel \$membrane
animate write pdb ./protein/protein_vacio_500.pdb beg 1 end 1 sel \$ligand
animate write dcd ./protein/protein_vacio_500.dcd sel \$ligand
exit
EOFK
######################################################################################################################

#correr el script de vmd para generar los ficheros
vmd -dispdev text -e mmgbsa.tcl

#Correr el namd2 en cada una de las carpetas para recalcular la energia potencial y plotearla
echo "Dinamica Molecula del Complejo"
/media/bioquimica/Datos2/Programas/NAMD_2.14_Linux-x86_64-multicore/namd2 +p4 ./complex/complex_mmgbsa.conf > ./complex/complex_mmgbsa.log
echo "Dinamica Molecula del receptor"
/media/bioquimica/Datos2/Programas/NAMD_2.14_Linux-x86_64-multicore/namd2 +p4 ./membrane/membrane_mmgbsa.conf > ./membrane/membrane_mmgbsa.log
echo "Dinamica Molecula del Ligando"
/media/bioquimica/Datos2/Programas/NAMD_2.14_Linux-x86_64-multicore/namd2 +p4 ./protein/protein_mmgbsa.conf > ./protein/protein_mmgbsa.log

#Extraer la energia potencial de los .log
grep ENERGY ./complex/complex_mmgbsa.log | grep -v Info | awk '{print $2," ",$14}' > ./complex/complex_pot.xvg
complex_pot=$(awk '{print $2}' ./complex/complex_pot.xvg)
complex_pot_average=$(awk '{ sum += $2; n++ } END { if (n > 0) print sum / n; }' ./complex/complex_pot.xvg)
grep ENERGY ./membrane/membrane_mmgbsa.log | grep -v Info | awk '{print $2," ",$14}' > ./membrane/membrane_pot.xvg
membrane_pot=$(awk '{print $2}' ./membrane/membrane_pot.xvg)
membrane_pot_average=$(awk '{ sum += $2; n++ } END { if (n > 0) print sum / n; }' ./membrane/membrane_pot.xvg)
grep ENERGY ./protein/protein_mmgbsa.log | grep -v Info | awk '{print $2," ",$14}' > ./protein/protein_pot.xvg
protein_pot=$(awk '{print $2}' ./protein/protein_pot.xvg)
protein_pot_average=$(awk '{ sum += $2; n++ } END { if (n > 0) print sum / n; }' ./protein/protein_pot.xvg)

#genera la salida de las variables anteriores en columnas 
columnas=$(paste -d" " <(echo "${complex_pot}") <(echo "${membrane_pot}") <(echo "${protein_pot}"))

#Calcular deltaG con MMGBSA=Epotcomplejo-Epotreceptor-Epotligando
deltaG=$(paste -d"        " <(echo "${complex_pot_average}") <(echo "${membrane_pot_average}") <(echo "${protein_pot_average}") | awk '{print $1 - $2 - $3}')

finalizado=$(date)

#Escribe el fichero de salida con las energias potenciales, los promedios y el deltaG
echo "complex_potential membrane_potential protein_potential
$columnas

hora de inicio: $inicio
hora de finalizacion: $finalizado
complex potential average: $complex_pot_average
membrane potential average: $membrane_pot_average 
protein potential average: $protein_pot_average
deltaG MMGBSA: $deltaG"            > deltaG_mmgbsa.out

#Imprime en la consola los resultados finales
tail -n 6 deltaG_mmgbsa.out

#Borrar los dcd generados para ahorrar espacio
rm ./complex/complejo_vacio_500.dcd
rm ./membrane/membrana_vacio_500.dcd
rm ./protein/protein_vacio_500.dcd
