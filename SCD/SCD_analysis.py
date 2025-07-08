import pandas as pd

# Cargar los datos desde el archivo CSV
file_path = 'membranescd.orderparSCD'
data = pd.read_csv(file_path, delim_whitespace=True, header=None, names=[
    'Leaflet', 'Frame', 'Lipid', 'Chain', 'ResID', 'Residue', 'Index', 'Carbon', '-SCD'
])

# Convertir la columna '-SCD' a tipo numérico
data['Frame'] = pd.to_numeric(data['Frame'], errors='coerce')
data['-SCD'] = pd.to_numeric(data['-SCD'], errors='coerce')

# Filtrar los datos para Lipid DOPE en el Leaflet 0
filtered_data = data[(data['Frame'] >= 0) & (data['Frame'] <= 4999)  & (data['Leaflet'] == 0)]

# Calcular el promedio de -SCD para cada Index
average_scd_by_index = filtered_data.groupby('Index', as_index=False)['-SCD'].mean()

# Redondear los valores a tres lugares decimales
average_scd_by_index['-SCD'] = average_scd_by_index['-SCD'].round(3)

# Guardar el resultado en el archivo SCD_total.log
output_file = 'GP_M1_TOTAL_Leaflet0.log'
average_scd_by_index.to_csv(output_file, sep='\t', index=False)

print(f"Promedio de -SCD (redondeado a tres lugares decimales) guardado en '{output_file}'.")


