#$ -S /bin/sh -cwd
##  AQUI EN ESTA LINEA DEBE SELECCIONAR LA CANTIDAD DE PROCESOS PARALELOS A EJECUTAR
#$  -pe mpi.singlehost 24
## AQUI SE CARGAN LAS VARIABLES DE ENTORNO:
## Load Environment Variables

export OMP_NUM_THREADS=24
module load VMD/1.9.3-foss-2018b-Python-2.7.15

vmd -dispdev text -e membranescd.tcl
