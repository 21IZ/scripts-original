#!/bin/bash -x

data=()

# Analizar las equilibraciones
cnt=1
cntmax=2

while [ $cnt -le $cntmax ]
do
    echo "P90_MEMBmineq-${cnt}_average.area"

    last_line=$(wc -l "P90_MEMBmineq-${cnt}_average.area" | awk '{print $1}')

    echo "$last_line"

    column=$(awk "NR>=2 && NR<=$last_line" "P90_MEMBmineq-${cnt}_average.area")

    data+=("$column")

    cnt=$(expr $cnt + 1)
done

# Analizar las producciones
cnt=50
cntmax=500

while [ $cnt -le $cntmax ]
do
    echo "P90_MEMBprod-3_${cnt}_average.area"

    last_line=$(wc -l "P90_MEMBprod-3_${cnt}_average.area" | awk '{print $1}')

    echo "$last_line"

    column=$(awk "NR>=2 && NR<=$last_line" "P90_MEMBprod-3_${cnt}_average.area")

    data+=("$column")

    cnt=$(expr $cnt + 50)
done

# Imprimir el contenido de 'data'
for item in "${data[@]}"
do
    echo "$item" >> test.log
done

grep DOPE test.log > DOPE_average_area.output
grep DOPG test.log > DOPG_average_area.output
grep TMCL2 test.log > TMCL2_average_area.output

#for a in *.output
#do
## Nombre del archivo de entrada
#archivo_entrada="${a}"
#
## Nombres de los archivos de salida
#archivo_con_0="${a}_con_0.txt"
#archivo_con_1="${a}_con_1.txt"
#
## Iterar sobre las líneas del archivo de entrada
#while IFS= read -r linea
#do
#    # Obtener el valor de la sexta columna (asumiendo que las columnas están separadas por espacios en blanco)
#    sexta_columna=$(echo "$linea" | awk '{print $6}')
#
#    # Evaluar el valor de la sexta columna y redirigir la línea al archivo correspondiente
#    if [ "$sexta_columna" -eq 0 ]; then
#        echo "$linea" >> "$archivo_con_0"
#    elif [ "$sexta_columna" -eq 1 ]; then
#        echo "$linea" >> "$archivo_con_1"
#    fi
#done < "$archivo_entrada"
#done


awk '{print $2}' DOPE_average_area.output > DOPE_average.area.agr
awk '{print $2}' DOPG_average_area.output > DOPG_average.area.agr
awk '{print $2}' TMCL2_average_area.output > TMCL2_average.area.agr
