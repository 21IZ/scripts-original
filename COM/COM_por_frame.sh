#! /bin/bash

psf=../complex_wi.psf
output1=COM_protein.txt
output2=COM_membrane.txt

######Crear script para VMD que genere los ficheros con los COM de membrana y proteina ############
cat <<EOFK >COM_por_frame.tcl
package require pbctools
package require bigdcd
proc myCOM { frame } {
   global COMprotein COMmembrane
   global COM_protein_out COM_membrane_out
   set protein [measure center \$COMprotein]
   set membrane [measure center \$COMmembrane]
   puts \$COM_protein_out "\$protein"
   puts \$COM_membrane_out "\$membrane"
 }
set COM_protein_out [open "${output1}" w]
set COM_membrane_out [open "${output2}" w]

set mol [mol new "${psf}" type psf waitfor all]
set COMprotein [atomselect top "protein"]
set COMmembrane [atomselect top "segname MEMB"]
bigdcd myCOM dcd ../P90_MEMBprod-3_50.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_100.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_150.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_200.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_250.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_300.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_350.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_400.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_450.dcd ../PBC_Wrap/P90_MEMBprod-3_wrap_500.dcd
bigdcd_wait
quit
EOFK
####################################################################################################

#correr el script de vmd para generar los ficheros
vmd -dispdev text -e COM_por_frame.tcl

#Extraer la coprdenada z de los centros de masa de la proteina y la membrana
z_protein=$(cat "${output1}" | awk '{print $3}')
z_membrane=$(cat "${output2}" | awk '{print $3}')

#genera la salida de las variables anteriores en columnas para poder restar los valores usando el comando awk y guardarlo en la variable delta_z_A
delta_z_A=$(paste -d" " <(echo "${z_protein}") <(echo "${z_membrane}") | awk '{print $1 - $2}')

#Convertir delta_z a nm y guardarlo e la variable delta_z_nm
delta_z_nm=$(paste -d" " <(echo "${delta_z_A}") | awk '{print $1/10}')

##generar la salida con las tres columnas en un fichero con el encabezado "z_protein z_membrane delta_z"
echo 'z_protein z_membrane delta_z_A delta_z_nm' > z_COM.out
paste -d" " <(echo "${z_protein}") <(echo "${z_membrane}") <(echo "${delta_z_A}") <(echo "${delta_z_nm}")>> z_COM.out

##generar el grafico para xmgrace
echo '@type xy
#@title \"Distance PaD membrane\"
#@s1 legend \"segname L and noh\"
#@xaxis label \"Time (ns)\"
#@yaxis label \"Distance (nm)\"
#0 0\n&\n0 0.0\n' > COM_distance.agr
awk '{print $4}' z_COM.out | grep -v "delta_z_nm" >> COM_distance.agr

xmgrace COM_distance.agr

