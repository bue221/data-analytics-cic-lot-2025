# Análisis del Dataset CIC IIoT 2025

## Descripción del Proyecto

Este proyecto realiza un análisis completo de datos de seguridad para redes IoT (Internet of Things) utilizando el dataset CIC IIoT 2025. El objetivo principal es identificar patrones en el tráfico de red que permitan distinguir entre operaciones benignas (normales) y ataques, con el fin de mejorar la seguridad de las redes IoT mediante la detección temprana de amenazas.

El análisis incluye:
- **Análisis descriptivo**: Exploración y visualización de datos para identificar patrones
- **Análisis prescriptivo**: Construcción de modelos de clasificación para detección de ataques
- **Evaluación**: Comparación de diferentes modelos de machine learning
- **Recomendaciones**: Estrategias de despliegue y mitigación de ataques

## Estructura del Proyecto

```
proyecto_DATA/
├── data/
│   ├── attack_data/          # Datos de ataques organizados por ventanas de tiempo
│   │   ├── attack_samples_1sec.csv
│   │   ├── attack_samples_2sec.csv
│   │   └── ... (hasta 10 segundos)
│   └── benign_data/          # Datos de tráfico benigno organizados por ventanas de tiempo
│       ├── benign_samples_1sec.csv
│       ├── benign_samples_2sec.csv
│       └── ... (hasta 10 segundos)
├── Taller_CIC_IIoT_dataset_2025.ipynb  # Notebook principal con el análisis
├── requirements.txt          # Dependencias de Python
└── README.md                 # Este archivo
```

## Requisitos e Instalación

### Requisitos del Sistema

- Python 3.8 o superior
- Jupyter Notebook o JupyterLab
- Make (opcional, pero recomendado para facilitar la instalación)

### Instalación Rápida (con Make)

La forma más sencilla de configurar el proyecto es usando Make:

```bash
# Configurar todo el proyecto (crea venv e instala dependencias)
make setup

# Ver todos los comandos disponibles
make help
```

### Instalación Manual

Si prefieres hacerlo manualmente o no tienes Make instalado:

1. **Clonar o descargar el proyecto**:
   ```bash
   cd proyecto_DATA
   ```

2. **Crear un entorno virtual (recomendado)**:
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # En Windows: venv\Scripts\activate
   ```

3. **Instalar las dependencias**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Iniciar Jupyter Notebook**:
   ```bash
   jupyter notebook
   ```

5. **Abrir el notebook**:
   - Abrir `Taller_CIC_IIoT_dataset_2025.ipynb`
   - Ejecutar las celdas en orden

### Comandos Make Disponibles

El proyecto incluye un `Makefile` con varios comandos útiles:

| Comando | Descripción |
|---------|-------------|
| `make setup` | Configura el proyecto completo (crea venv e instala dependencias) |
| `make install` | Instala las dependencias del proyecto |
| `make install-dev` | Instala dependencias incluyendo herramientas de desarrollo (JupyterLab, kernel) |
| `make run-notebook` | Inicia Jupyter Notebook |
| `make run-lab` | Inicia JupyterLab |
| `make check-env` | Verifica que el entorno esté configurado correctamente |
| `make test` | Ejecuta tests básicos de verificación |
| `make clean` | Limpia archivos temporales y cache de Python |
| `make clean-all` | Limpia todo incluyendo el entorno virtual |
| `make update` | Actualiza las dependencias |
| `make info` | Muestra información del entorno |
| `make help` | Muestra todos los comandos disponibles |

## Estructura de los Datos

### Organización de los Datos

Los datos están organizados en dos directorios principales:

- **`attack_data/`**: Contiene archivos CSV con datos de diferentes tipos de ataques:
  - **DoS (Denial of Service)**: Ataques que buscan interrumpir servicios
  - **DDoS (Distributed Denial of Service)**: Ataques distribuidos
  - **Reconnaissance**: Ataques de reconocimiento (escaneo de puertos, etc.)
  - **MitM (Man-in-the-Middle)**: Ataques de interceptación

- **`benign_data/`**: Contiene archivos CSV con datos de tráfico normal/benigno

Cada archivo está organizado por ventanas de tiempo (1 a 10 segundos), permitiendo análisis comparativos de diferentes duraciones de tiempo.

### Estructura de Columnas

Los archivos CSV contienen las siguientes columnas principales:

- **Columnas de identificación**:
  - `device_name`: Nombre del dispositivo IoT
  - `device_mac`: Dirección MAC del dispositivo
  - `timestamp`, `timestamp_start`, `timestamp_end`: Marcas temporales

- **Columnas de etiquetas**:
  - `label1`: Clase principal (attack/benign)
  - `label2`: Categoría de ataque (dos, ddos, reconnaissance, mitm)
  - `label3`: Nombre específico del ataque (tcp-flood, syn-flood, etc.)
  - `label4`: Nombre completo del escenario (ej: `dos_tcp-flood`)
  - `label_full`: Etiqueta completa descriptiva

- **Características extraídas** (90+ columnas):
  - Métricas de flujos de red (duración, número de paquetes, etc.)
  - Estadísticas de longitud de paquetes (promedio, máximo, mínimo, desviación estándar)
  - Tiempos entre llegadas de paquetes (IAT - Inter-Arrival Times)
  - Estados idle y active de los flujos
  - Otras características estadísticas del tráfico de red

## Fases del Análisis

### 1. Comprensión del Negocio

**Objetivo**: Identificar el propósito del análisis y los objetivos de negocio.

El objetivo principal es mejorar la seguridad de las redes IoT mediante:
- Detección temprana de amenazas
- Identificación de patrones anómalos en el tráfico de red
- Implementación de estrategias de mitigación efectivas

### 2. Comprensión de los Datos

**Objetivo**: Explorar y entender la estructura, contenido y características de los datos.

**Actividades realizadas**:
- Exploración de los directorios `attack_data` y `benign_data`
- Carga y visualización de muestras de datos
- Análisis de tipos de datos y estructura de columnas
- Identificación de valores únicos en columnas de etiquetas
- Verificación de valores faltantes
- Estadísticas descriptivas de los datos

**Hallazgos clave**:
- Los datos están organizados por ventanas de tiempo (1-10 segundos)
- Se identificaron múltiples tipos de ataques: DoS, DDoS, Reconnaissance, MitM
- Los datos contienen 90+ características numéricas extraídas
- No hay valores faltantes significativos en los archivos analizados
- La distribución entre clases 'attack' y 'benign' presenta cierto desbalance

### 3. Preparación de los Datos

**Objetivo**: Limpiar, transformar y preparar los datos para el modelado.

**Procesos realizados**:

1. **Combinación de datos**: Concatenación de datos de ataque y benignos
2. **Eliminación de columnas**: Se eliminaron columnas irrelevantes para el modelado:
   - `device_name`
   - `device_mac`
   - `label_full`
3. **Codificación categórica**: Aplicación de one-hot encoding a variables categóricas
4. **Manejo de valores faltantes e infinitos**:
   - Reemplazo de valores infinitos con NaN
   - Imputación de valores faltantes usando la mediana
5. **Normalización**: Escalado de características numéricas usando `StandardScaler`
6. **Separación de características y objetivo**:
   - `X`: Matriz de características (111 columnas después del preprocesamiento)
   - `y`: Variable objetivo (`label1`: attack/benign)

### 4. Modelado - Análisis Descriptivo

**Objetivo**: Realizar análisis estadísticos y visualizaciones para describir las características de los datos.

**Visualizaciones realizadas**:
- Distribución de las clases (attack vs benign)
- Histogramas de características clave
- Box plots para comparar distribuciones entre clases
- Scatter plots para identificar relaciones entre características

**Hallazgos del análisis descriptivo**:
- **Características discriminativas identificadas**:
  - Duración de los flujos
  - Número total de paquetes (enviados y recibidos)
  - Longitud total de paquetes
  - Tiempos entre llegadas de paquetes (IATs)
  - Duraciones de estados 'idle' y 'active' de los flujos

- **Diferencias observadas**:
  - Los ataques presentan picos inusuales en número de paquetes
  - Patrones distintos en IATs y duraciones de flujos comparados con tráfico benigno
  - Diferencias significativas en mediana y dispersión de características clave
  - Los scatter plots sugieren que combinaciones de características pueden separar visualmente los clusters de ataque y benigno

### 5. Modelado - Análisis Prescriptivo

**Objetivo**: Desarrollar modelos de machine learning para predecir y detectar ataques.

**Modelos implementados**:

1. **Random Forest Classifier**
   - Modelo principal para detección de ataques
   - Adecuado para relaciones no lineales y alta dimensionalidad
   - Esperado rendimiento alto (>0.95 en métricas clave)

2. **Logistic Regression**
   - Modelo de línea base lineal
   - Rendimiento esperado moderado (0.7-0.9)

3. **Dummy Classifier**
   - Modelo de referencia simple (estrategia estratificada)
   - Rendimiento esperado cercano a la proporción de clase mayoritaria
   - Confirma que los otros modelos aprenden patrones reales

**Proceso de entrenamiento**:
- División de datos: 80% entrenamiento, 20% prueba
- Estratificación para mantener proporción de clases
- `random_state=42` para reproducibilidad

### 6. Evaluación

**Objetivo**: Evaluar el rendimiento de los modelos y compararlos.

**Métricas utilizadas**:
- **Accuracy**: Precisión general del modelo
- **Precision**: Precisión de las predicciones positivas
- **Recall**: Capacidad de detectar todos los casos positivos
- **F1-score**: Media armónica de precision y recall
- **Confusion Matrix**: Matriz de confusión para análisis detallado

**Resultados esperados**:

**Random Forest Model**:
- Accuracy: > 0.95
- Precision (attack): > 0.95
- Recall (attack): > 0.95
- F1-score (attack): > 0.95
- Alta capacidad de minimizar falsos positivos y falsos negativos

**Logistic Regression Baseline**:
- Accuracy: 0.7 - 0.9
- Rendimiento inferior al Random Forest, sugiriendo relaciones no lineales

**Dummy Classifier Baseline**:
- Accuracy: Cercana a la proporción de clase mayoritaria
- Confirma que los modelos aprenden patrones reales

**Comparación de modelos**:
El modelo Random Forest demuestra superioridad significativa sobre las líneas base, con métricas consistentemente altas para la detección de ataques, lo que lo hace ideal para sistemas de detección de intrusiones.

### 7. Despliegue y Recomendaciones

**Características clave para detección en tiempo real**:
- Duración del flujo
- Longitud total/máxima de paquetes
- Tiempos entre llegadas (IATs)
- Tiempos idle/active de flujos

**Recomendaciones de despliegue**:
- **Modelo recomendado**: Random Forest para detección en tiempo real
- **Optimización para dispositivos IoT**: Considerar poda de árboles o cuantización para recursos limitados
- **Monitoreo**: Priorizar las características identificadas como altamente discriminativas

**Estrategias de respuesta a ataques**:

1. **DoS/DDoS**:
   - Bloqueo de direcciones IP de origen maliciosas
   - Limitación de tasas de tráfico anómalo
   - Redireccionamiento del tráfico sospechoso (blackholing)

2. **Reconnaissance**:
   - Activación de alertas de seguridad
   - Aumento de monitorización en dispositivos escaneados
   - Implementación de políticas de firewall más restrictivas

3. **MitM (Man-in-the-Middle)**:
   - Verificación de tablas ARP
   - Aseguramiento de protocolos de comunicación
   - Aislamiento de dispositivos comprometidos

4. **Sistema automatizado**:
   - Implementar sistema de respuesta automatizada
   - Acciones predefinidas basadas en tipo de alerta
   - Notificaciones a administradores de seguridad

## Futuras Mejoras

1. **Algoritmos avanzados**: Explorar Gradient Boosting, Redes Neuronales
2. **Selección de características**: Optimización para reducir dimensionalidad
3. **Ventanas de tiempo**: Experimentar con diferentes duraciones
4. **Balanceo de clases**: Técnicas de oversampling/undersampling si es necesario
5. **Validación en producción**: Probar en escenarios de red IoT reales o simulaciones complejas

## Uso del Notebook

### Ejecución en Local

El notebook ha sido adaptado para ejecutarse en local (no requiere Google Colab):

1. **Verificar configuración**: La primera celda verifica que los directorios de datos existan
2. **Ejecutar celdas en orden**: Ejecutar las celdas secuencialmente desde el inicio
3. **Rutas relativas**: Todas las rutas han sido adaptadas para usar rutas relativas desde el directorio del proyecto

### Notas Importantes

- **Directorio de trabajo**: Asegúrate de ejecutar el notebook desde el directorio raíz del proyecto
- **Rutas de datos**: Los datos deben estar en `data/attack_data/` y `data/benign_data/`
- **Memoria**: Los archivos de datos pueden ser grandes; considera usar procesamiento por chunks si tienes memoria limitada

## Dependencias Principales

- **pandas**: Manipulación y análisis de datos
- **numpy**: Operaciones numéricas
- **scikit-learn**: Machine learning (modelos, preprocesamiento, métricas)
- **matplotlib**: Visualizaciones básicas
- **seaborn**: Visualizaciones estadísticas avanzadas
- **IPython/Jupyter**: Entorno de notebook interactivo

## Manejo de Errores

El código incluye manejo robusto de errores:

- **Validación de archivos**: Verificación de existencia antes de cargar
- **Manejo de valores infinitos**: Reemplazo y limpieza automática
- **Imputación de valores faltantes**: Uso de mediana para robustez
- **Mensajes informativos**: Errores claros y descriptivos

## Contribuciones

Este proyecto es parte de un taller académico sobre análisis de datos de seguridad IoT. Para mejoras o sugerencias, por favor contacta al equipo del proyecto.

## Licencia

Este proyecto es de uso académico y educativo.

---

**Fecha de última actualización**: 2025

**Versión**: 1.0

