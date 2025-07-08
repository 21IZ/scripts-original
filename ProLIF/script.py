import MDAnalysis as mda
from MDAnalysis.topology.guessers import guess_types
import prolif as plf
import csv
import matplotlib.pyplot as plt
import numpy as np

# load topology and trajectory
u = mda.Universe("../complex_wi.psf", "../P90_MEMBprod-3_50.dcd")

guessed_elements = guess_types(u.atoms.names)

u.add_TopologyAttr('elements', guessed_elements)

print(u.atoms.elements)  # returns an array of guessed elements

### ONLY WORKS AS INTENDED IN MDAnalysis < 3.0
# store ALL coordinates
all_coordinates = [ts.positions for ts in u.trajectory]
# make numpy array
all_coordinates = np.array(all_coordinates)

#Check that all coordinates are identical, frame by frame
for i, ts in enumerate(u.trajectory):
   match = np.allclose(ts.positions, all_coordinates[i])
   if not match:
       print(f"Coordinate mismatch at frame {i}")
print("done")

# create selections for both protein components
small_protein_selection = u.select_atoms("protein or resname YND")
large_protein_selection = u.select_atoms("segid MEMB")
print(small_protein_selection, large_protein_selection)

#Imprime rl fingerprint
fp = plf.Fingerprint()
fp.run(u.trajectory[1:-1], small_protein_selection, large_protein_selection)
print(fp)

#Guarda la salida en un fichero fingerprint.pkl
fp.to_pickle("fingerprint_50ns.pkl")

#Analysis de interacciones in Boolean (True and False)
df = fp.to_dataframe()
df.to_csv('fingerprint_50ns.csv')

#Analysis de interacciones en % total
df_percentage = (df.mean().sort_values(ascending=False).to_frame(name="%").T * 100)
df_percentage.to_csv('fingerprint_percentage_50ns.csv')
########################DELETE_DUPLICATE####################################
import csv

def analizar_csv(input_file, output_file):
    # Leer el archivo CSV de entrada
    with open(input_file, 'r') as file:
        reader = csv.reader(file)
        rows = list(reader)

    # Obtener las dos primeras filas
    first_row = rows[0]
    second_row = rows[1]

    # Encontrar las columnas con valores iguales en las dos primeras filas
    columnas_a_eliminar = []
    for i in range(len(first_row)):
        if first_row[i] == second_row[i]:
            columnas_a_eliminar.append(i)

    # Eliminar las columnas en todas las filas
    filas_resultantes = []
    for row in rows:
        nueva_fila = [row[i] for i in range(len(row)) if i not in columnas_a_eliminar]
        filas_resultantes.append(nueva_fila)

    # Escribir el resultado en un nuevo archivo CSV
    with open(output_file, 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerows(filas_resultantes)

analizar_csv('fingerprint_percentage_50ns.csv', 'fingerprint_percentage_50ns.csv')
############################################################################

#Plotear el grafico de interacciones vs time
plot = fp.plot_barcode()

f = open("texto.svg", "w")
print(plot, file=f)
f.close

print("You will find the plot in texto.svg")
