#!/bin/bash
###Para crear la lista de contactos. Hay que copiar el script new_contacts.tcl para el directorio y editalo para que lea el psf y la trayectoria correcta.
vmd -dispdev text -e newcontacts_Lig-Rec.tcl
##### Orderar lista de menor a mayor
cat contact_AB.dat |sort -k3n -t-  > sort_contact_AB.dat
#### Crear lista de contactos del receptor y del ligando
awk '{print $1}' sort_contact_AB.dat > complex_residue.list
awk '{print $4}' sort_contact_AB.dat > complex_lig_residue.list
###### Obterner los nueros de residuos reales para receptor y ligando
./create_renumber_script_vmd.sh ../complex_wi.psf ../complex_wi.pdb > vmd_renumber_script.tcl
vmd -dispdev text -e vmd_renumber_script.tcl
#### los numeros corectos de residuos estan en los ficheros contact_resid_numbers(receptor) contact_lig_resid_numbers (ligando)
##### Cambiar los numeros del receptor por los correctos (mezcla los ficheros y borra la columna delos numeros viejos)
paste contact_resid_numbers sort_contact_AB.dat | awk '!($2="")' > sort_contact_AB_renumber_rec.dat
##### Cambiar los numeros del ligando por los correctos (mezcla los ficheros y borra la columna delos numeros viejos)
paste sort_contact_AB_renumber_rec.dat contact_lig_resid_numbers | awk '{print $1,$2,$3,$12,$5,$6,$7,$8,$9,$10,$11}'> sort_contact_AB_renumber.dat
rm sort_contact_AB_renumber_rec.dat complex_residue.list complex_lig_residue.list vmd_renumber_script.tcl
