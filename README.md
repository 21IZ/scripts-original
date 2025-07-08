# 🧬 Scripts para Análisis de Simulaciones de Dinámica Molecular

Una colección completa de scripts especializados para el análisis exhaustivo de simulaciones de dinámica molecular, con enfoque en sistemas proteína-membrana y interacciones proteína-ligando.

## 🏗️ Estructura del Proyecto

```
Scripts/
├── BSA/                    # Análisis de Superficie Accesible al Solvente
├── COM/                    # Centro de Masa
├── HBONDS/                 # Puentes de Hidrógeno
├── Last_Frame/             # Procesamiento de Último Frame
├── MEMPLUGING/             # Análisis de Membranas
├── MMGBSA/                 # Cálculos Energéticos MM-GBSA
├── Momento_Dipolo/         # Propiedades Eléctricas
├── NEWCONTACTS/            # Análisis de Contactos
├── PBC_WRAP/               # Condiciones de Contorno Periódicas
├── ProLIF/                 # Análisis de Interacciones Proteína-Ligando
├── SCD/                    # Parámetros de Orden Deuterio
├── Secondary_Structure/    # Estructura Secundaria
└── Tilt_Angle/            # Ángulo de Inclinación
```

## 🔧 Instalación y Dependencias

### Software Base Requerido

- **VMD** - Para todos los módulos .tcl
- **NAMD** - Para módulo MMGBSA
- **Python 3.x** - Para análisis con ProLIF y estadísticas
- **Gnuplot** - Para visualización de datos
- **AWK/Bash** - Para scripts de procesamiento

### Plugins VMD Necesarios

| Módulo | Plugins Requeridos |
|--------|-------------------|
| MEMPLUGING | `lipidarea`, `membranethickness`, `membranescd` |
| Momento_Dipolo | `pbctools`, `bigdcd` |
| PBC_WRAP | `pbctools` |
| HBONDS | `hbonds` (nativo VMD) |

### Librerías Python

```bash
# Para ProLIF
pip install MDAnalysis<3.0 prolif matplotlib numpy

# Para análisis estadístico
pip install pandas

# Dependencias adicionales
pip install argparse collections csv re os
```

## 📊 Módulos Disponibles

### 🔬 BSA - Superficie Accesible al Solvente
- **Propósito**: Cálculo de SASA para complejos proteína-ligando
- **Algoritmo**: Lee & Richards con radio de prueba 1.4 Å
- **Fórmula**: `Área_enterrada = (SASA_ligando + SASA_receptor - SASA_complejo) / 2`

### 📍 COM - Centro de Masa
- **Componentes**: Proteína y membrana por frame
- **Salida**: Archivos separados con formato `frame X Y Z`

### 🔗 HBONDS - Puentes de Hidrógeno
- **Criterios**: Distancia D-A < 3.0 Å, Ángulo D-H-A < 20°
- **Análisis**: Frecuencias y estadísticas detalladas

### ⚡ MMGBSA - Cálculos Energéticos
- **Método**: MM-GBSA para energía de unión
- **Componentes**: Complejo, membrana y proteína
- **Temperatura**: 310 K, Campo de fuerza CHARMM36

### 🧪 MEMPLUGING - Análisis Completo de Membranas

#### Área por Lípido
- **Lípidos soportados**: DOPG, DOPE, TMCL2
- **Análisis**: Leaflet específico

#### Grosor de Membrana
- **Método**: Plugin membranethickness 1.1
- **Salida**: Mapas 2D y 3D, conversión DX→TIFF

#### Parámetros SCD
- **Propósito**: Orden deuterio en cadenas lipídicas
- **Análisis**: Estadístico con pandas

### 🔌 ProLIF - Interacciones Proteína-Ligando
- **Tecnología**: MDAnalysis + ProLIF
- **Análisis**: Huellas dactilares de interacciones
- **Procesamiento**: Conversión True/False → 1/0, análisis de porcentajes

### 📐 Análisis Estructural
- **Secondary_Structure**: Análisis de estructura secundaria
- **Tilt_Angle**: Ángulo de inclinación de hélices TM
- **Momento_Dipolo**: Propiedades eléctricas

## 🚀 Flujo de Trabajo Recomendado

### 1. Preparación Inicial
```bash
# Aplicar PBC wrapping
cd Scripts/PBC_WRAP/
vmd -dispdev text -e PBC_Wrap.tcl

# Procesar último frame si necesario
cd ../Last_Frame/
vmd -dispdev text -e Last_Frame_loop.tcl
```

### 2. Análisis Energético
```bash
cd ../MMGBSA/
./mmgbsa.sh
```

### 3. Análisis Estructural
```bash
# Centro de masa
cd ../COM/
./COM_por_frame.sh

# Estructura secundaria
cd ../Secondary_Structure/
./Secondary_Structure.sh

# Ángulo de inclinación
cd ../Tilt_Angle/
./Tilt_Angle.sh
./Unir_Tilt_Angle.sh
```

### 4. Análisis de Membrana
```bash
cd ../MEMPLUGING/

# Área por lípido
cd Area_per_Lipid/
./Area_per_Lipid.sh
./Unificar_average.area.sh

# Grosor de membrana
cd ../Membrane_Ticknesses/
vmd -dispdev text -e membrane_ticknesses.tcl
vmd -dispdev text -e ticknessesmap.tcl
./Membrane_thickness_dx2tiff.sh
gnuplot ticknessmap.gnuplot

# Parámetros de orden
cd ../SCD/
./SCD_Ejecutar.sh
python SCD_analysis.py
```

### 5. Análisis de Interacciones
```bash
# Puentes de hidrógeno
cd ../../HBONDS/
vmd -dispdev text -e hbonds.tcl
./hbonds_output_analysis.sh secuencia.txt output.dat

# Contactos
cd ../NEWCONTACTS/
./extract_complex_contacts.sh
./newcontacts_output_analysis.sh

# Análisis con ProLIF
cd ../ProLIF/
python script.py
python process_fingerprint.py input.csv output_dir/
python process_fingerprint_percentage.py input.csv output_dir/
```

### 6. Análisis de Propiedades Físicas
```bash
# Superficie accesible
cd ../BSA/
vmd -dispdev text -e BSA.tcl
./Combinar_Graficos_BSA.sh

# Momento dipolar
cd ../Momento_Dipolo/
vmd -dispdev text -e dipole_por_frame.tcl
gnuplot electric_dipole_orientation.gnuplot
```

## 📖 Guías de Uso Específicas

### Configuración MMGBSA
Estructura de carpetas requerida:
```
MMGBSA/
├── mmgbsa.sh
├── complex/
│   └── complex_mmgbsa.conf
├── membrane/
│   └── membrane_mmgbsa.conf
└── protein/
    └── protein_mmgbsa.conf
```

### Análisis de Puentes de Hidrógeno
```bash
# Preparar archivo de secuencia
echo "MET ALA GLY..." > secuencia.txt

# Ejecutar análisis
./hbonds_output_analysis.sh secuencia.txt hbonds_output.dat
```

### ProLIF - Configuración Python
```python
# Ejemplo de uso básico
import MDAnalysis as mda
from prolif import Molecule, Fingerprint

# Cargar trayectoria
u = mda.Universe("topology.psf", "trajectory.dcd")

# Configurar análisis
fp = Fingerprint()
fp.run(u.trajectory[::10])  # Cada 10 frames
```

## ⚠️ Notas Importantes

1. **Duplicación SCD**: Existe duplicación entre `Scripts/SCD/` y `Scripts/MEMPLUGING/SCD/`
2. **Compatibilidad**: MDAnalysis debe ser < 3.0 para ProLIF
3. **Sistemas de Colas**: Algunos scripts están configurados para SGE
4. **Configuración MMGBSA**: Requiere estructura de carpetas específica



**Desarrollado para análisis avanzado de simulaciones de dinámica molecular** 🧬
