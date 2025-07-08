const fs = require('fs');
const path = require('path');

function crearArbolDirectorio(directorio, prefijo = '') {
    let resultado = '';
    
    // Leer el contenido del directorio y filtrar elementos no deseados
    const elementos = fs.readdirSync(directorio)
        .filter(elemento => {
            // Ignorar node_modules y archivos/carpetas que empiezan con punto
            return elemento !== 'node_modules' && !elemento.startsWith('.');
        })
        .sort(); // Ordenar alfabéticamente
    
    elementos.forEach((elemento, index) => {
        const rutaCompleta = path.join(directorio, elemento);
        const esUltimo = index === elementos.length - 1;
        const conector = esUltimo ? '└── ' : '├── ';
        const siguientePrefijo = esUltimo ? '    ' : '│   ';
        
        try {
            const stat = fs.statSync(rutaCompleta);
            
            // Añade el elemento actual con el conector apropiado
            resultado += `${prefijo}${conector}${elemento}\n`;
            
            // Si es un directorio, explora recursivamente
            if (stat.isDirectory()) {
                resultado += crearArbolDirectorio(rutaCompleta, prefijo + siguientePrefijo);
            }
        } catch (error) {
            resultado += `${prefijo}${conector}Error accediendo a: ${elemento}\n`;
        }
    });
    
    return resultado;
}

// Directorio que quieres explorar (por defecto el directorio actual)
const directorioInicial = './';
const nombreArchivo = 'estructura_proyecto.txt';

try {
    console.log('Generando árbol de directorios...');
    
    // Obtén el nombre del directorio raíz
    const nombreDirectorioRaiz = path.basename(path.resolve(directorioInicial));
    
    // Genera el árbol comenzando con el directorio raíz
    let arbol = nombreDirectorioRaiz + '\n' + crearArbolDirectorio(directorioInicial);
    
    // Guarda el resultado en un archivo
    fs.writeFileSync(nombreArchivo, arbol);
    
    console.log(`\nÁrbol de directorios generado en ${nombreArchivo}`);
    // También muestra el árbol en la consola para referencia
    console.log('\n' + arbol);
} catch (error) {
    console.error('Error:', error);
}
