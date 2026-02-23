# Proyecto RNA-seq 2026

Autor: Marina Mendoza Suárez
Fecha: 23 de febrero de 2026

## Análisis de expresión diferencial en tumores prostáticos TRAMP (SRP092108)

---

## 1. Descripción general

Este repositorio contiene un análisis reproducible de expresión génica diferencial utilizando datos públicos de RNA-seq del estudio **SRP092108**, obtenidos mediante la plataforma **recount3** (Bioconductor).

El objetivo del proyecto fue comparar perfiles transcriptómicos entre:

* Tumores prostáticos transgénicos (modelo TRAMP)
* Tejido prostático normal

y caracterizar los cambios moleculares asociados a la transformación tumoral.

---

## 2. Datos

* Organismo: *Mus musculus*
* Estudio: SRP092108
* Fuente: recount3
* Nivel de cuantificación: gene-level counts
* Total de muestras: 1,419

  * 980 tumores (Transgene positive)
  * 439 tejido normal (Transgene negative)

Los datos fueron descargados directamente desde recount3 en formato `RangedSummarizedExperiment`.

---

## 3. Estrategia de análisis

El flujo de trabajo implementado fue el siguiente:

1. Descarga y construcción del objeto `RangedSummarizedExperiment` (recount3).
2. Conversión de cobertura a cuentas de lectura (`compute_read_counts`).
3. Filtrado de genes de baja expresión (`filterByExpr`).
4. Normalización TMM (`edgeR`).
5. Transformación `voom` (`limma`).
6. Ajuste de modelo lineal y análisis de expresión diferencial (`eBayes`).
7. Corrección por múltiples pruebas (FDR, Benjamini–Hochberg).
8. Anotación de genes con `org.Mm.eg.db`.
9. Visualización mediante:

   * PCA
   * Volcano plot
   * Heatmap de los 50 genes más significativos.

---

## 4. Resultados principales

El análisis mostró una reprogramación transcriptómica extensa entre tumores y tejido normal.

* El PCA evidenció una separación clara por condición biológica, con el primer componente principal explicando aproximadamente 62% de la varianza total.
* El análisis de expresión diferencial identificó miles de genes significativamente alterados.
* Los tumores presentaron sobreexpresión de genes asociados a ciclo celular, mitosis y replicación de ADN (por ejemplo: *Cenpf*, *Clspn*, *Esco2*, *Spag5*).
* Se observó represión marcada de genes asociados a diferenciación prostática normal, incluyendo *Pbsn* y *Tgm4*.

Estos patrones son consistentes con mecanismos clásicos de tumorigenesis: proliferación sostenida y pérdida de identidad tisular.

El reporte completo se encuentra en:

`REPORTE.md`

---

## 5. Estructura del repositorio

```
code/
  01_read_data_to_r/
  02_explore_data/
  03_differential_expression/
  04_annotation/

plots/
  02_explore_data/
  03_differential_expression/

processed-data/
  01_read_data_to_r/

README.md
REPORTE.md
proyecto_rnaseq_2026.Rproj
```

### code/

Contiene los scripts organizados por etapa del análisis.

### plots/

Contiene las figuras generadas:

* PCA
* Volcano plot
* Heatmap

### processed-data/

Incluye objetos intermedios reproducibles (`.rds`, metadatos).

---

## 6. Reproducibilidad

Entorno de trabajo:

* R 4.5.2
* Bioconductor 3.22

Paquetes principales:

* recount3
* edgeR
* limma
* AnnotationDbi
* org.Mm.eg.db

Para reproducir el análisis, ejecutar secuencialmente los scripts contenidos en el directorio `code/`.

---

## 7. Contexto académico

Proyecto desarrollado como parte del curso de análisis de RNA-seq (2026). El objetivo fue implementar un pipeline completo y reproducible para análisis de expresión diferencial utilizando datos públicos.