# Análisis de Expresión Diferencial en Tumores Prostáticos TRAMP (SRP092108)

## Resumen

En este estudio se realizó un análisis de expresión diferencial utilizando datos públicos de RNA-seq disponibles en la plataforma **recount3**, correspondientes al estudio SRP092108 en ratón. Se compararon tumores prostáticos transgénicos del modelo TRAMP contra tejido prostático normal. El análisis incluyó 1,419 muestras (980 tumores y 439 controles), lo que permitió detectar cambios transcriptómicos con alto poder estadístico.

Los resultados revelan una reprogramación transcripcional extensa caracterizada por activación robusta de programas proliferativos y mitóticos, junto con supresión marcada de genes asociados a diferenciación prostática. Estos hallazgos son consistentes con mecanismos clásicos de tumorigenesis, incluyendo proliferación sostenida y pérdida de identidad tisular.

---

# Introducción

La progresión tumoral implica alteraciones profundas en la regulación génica que afectan proliferación, diferenciación y estabilidad genómica. El modelo TRAMP (Transgenic Adenocarcinoma of Mouse Prostate) es ampliamente utilizado para estudiar la transformación maligna prostática y los cambios moleculares asociados.

El objetivo de este proyecto fue:

* Identificar genes diferencialmente expresados entre tumores TRAMP y tejido prostático normal.
* Caracterizar patrones globales de variación transcriptómica.
* Interpretar los cambios observados dentro de un marco conceptual de biología tumoral.

---

# Materiales y Métodos

## Datos

Los datos fueron obtenidos mediante el paquete **recount3** de Bioconductor. Se seleccionó el estudio:

* SRP092108
* Organismo: *Mus musculus*
* 1,419 muestras totales

  * 980 tumores (Transgene positive)
  * 439 tejido normal (Transgene negative)

Se descargaron cuentas génicas (gene-level counts).

---

## Preprocesamiento

1. Conversión de cobertura a cuentas de lectura mediante `compute_read_counts()`.
2. Filtrado de genes de baja expresión usando `filterByExpr`.
3. Normalización TMM con `calcNormFactors` (edgeR).
4. Transformación `voom` para modelado lineal con `limma`.

---

## Análisis de Expresión Diferencial

Se construyó una matriz de diseño comparando:

Tumor vs Normal

Se aplicó el pipeline:

* edgeR (normalización)
* limma-voom (modelado lineal)
* eBayes (moderación empírica de varianzas)

Los genes con FDR (Benjamini-Hochberg) < 0.05 fueron considerados diferencialmente expresados.

---

# Resultados

## Análisis exploratorio: PCA

El análisis de componentes principales reveló una separación clara entre muestras tumorales y tejido normal en el primer componente principal (PC1), el cual explicó aproximadamente el 62% de la variación total.

Este valor es notablemente alto en estudios transcriptómicos, lo que indica que el estado tumoral constituye la principal fuente de variabilidad biológica en el conjunto de datos. La separación observada sugiere que la transformación oncogénica induce un programa transcripcional dominante que supera otras posibles fuentes de variación técnica o biológica.

Además, las muestras tumorales mostraron agrupamiento compacto, lo cual sugiere una reprogramación transcriptómica consistente entre individuos.

(Figura 1: PCA Tumor vs Normal)

---

## Análisis global de expresión diferencial

El volcano plot mostró una distribución amplia y simétrica de cambios de expresión, con numerosos genes presentando magnitudes elevadas de cambio (|log2FC| > 5).

La abundancia de genes con valores de FDR extremadamente bajos refleja tanto la fuerte señal biológica como el alto poder estadístico derivado del tamaño muestral. Esto indica que los cambios detectados son consistentes entre múltiples muestras y no producto de variación aleatoria.

(Figura 2: Volcano plot)

---

## Genes representativos y programas biológicos

### Genes sobreexpresados en tumores

Entre los genes con mayor incremento en tumores destacan:

* *Cenpf*
* *Clspn*
* *Esco2*
* *Spag5*
* *Cdkn2a*

Estos genes participan en:

* Progresión del ciclo celular
* Replicación de ADN
* Segregación cromosómica
* Control mitótico

Este patrón es consistente con activación de programas proliferativos sostenidos, uno de los principios fundamentales descritos en los hallmarks del cáncer.

También se observaron genes asociados a programas de desarrollo y diferenciación neuronal:

* *Sox1*
* *Dcx*
* *Insm1*

Lo cual sugiere plasticidad celular y posible reprogramación de linaje, fenómenos asociados a progresión tumoral avanzada y desdiferenciación.

---

### Genes reprimidos en tumores

Entre los genes más fuertemente reprimidos en tumores se encuentran:

* *Pbsn* (Probasin)
* *Tgm4*
* *Ren1*

Estos genes están relacionados con funciones secretoras y diferenciación prostática normal. Su represión indica pérdida de identidad epitelial, otro rasgo característico de transformación maligna.

---

## Heatmap de genes diferencialmente expresados

El heatmap de los 50 genes más significativos mostró agrupamiento claro por condición biológica, confirmando que los tumores poseen un perfil transcriptómico coordinado y distintivo.

La organización en bloques sugiere activación y represión concertadas de módulos génicos, lo cual refleja regulación transcripcional a gran escala.

(Figura 3: Heatmap Top 50 genes)

---

# Interpretación Biológica Integrada

En conjunto, los resultados evidencian una reprogramación transcriptómica extensa en tumores del modelo TRAMP.

Se observa:

* Activación robusta de programas proliferativos y mitóticos.
* Aumento de genes asociados a replicación y control del ciclo celular.
* Evidencia de plasticidad celular y posible reprogramación de linaje.
* Supresión marcada de genes característicos del epitelio prostático diferenciado.

Este patrón refleja múltiples principios clásicos de tumorigenesis:

* Señalización proliferativa sostenida
* Pérdida de identidad tisular
* Alteración de programas de diferenciación

La magnitud de los cambios observados, junto con la fuerte separación en PCA, indica que el estado tumoral domina la arquitectura transcriptómica global en este modelo experimental.

---

# Discusión

Los hallazgos son consistentes con estudios previos del modelo TRAMP y con principios generales de biología tumoral. La activación de genes mitóticos y de replicación sugiere expansión celular activa, mientras que la represión de marcadores prostáticos indica desdiferenciación progresiva.

El tamaño muestral elevado permitió detectar cambios con gran precisión estadística, reforzando la robustez de las conclusiones.

Este análisis demuestra cómo datos públicos accesibles vía recount3 pueden utilizarse para investigar mecanismos moleculares de cáncer mediante pipelines reproducibles en Bioconductor.

---

# Conclusión

El análisis de expresión diferencial del estudio SRP092108 identificó cambios transcriptómicos consistentes con proliferación tumoral, pérdida de diferenciación y reprogramación celular.

El pipeline implementado utilizando recount3, edgeR y limma-voom fue robusto, reproducible y adecuado para análisis de RNA-seq a gran escala.

---

# Figuras

1. PCA Tumor vs Normal
2. Volcano plot
3. Heatmap Top 50 genes