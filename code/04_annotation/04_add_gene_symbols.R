library(here)
library(dplyr)
library(AnnotationDbi)
library(org.Mm.eg.db)

res <- read.csv(here("plots", "03_differential_expression", "DE_results_SRP092108.csv"),
                row.names = 1)

res$ensembl <- rownames(res)

## Your Ensembl IDs include version suffixes like ".9" — remove them
res$ensembl_clean <- sub("\\..*$", "", res$ensembl)

## Map to gene symbols
res$symbol <- mapIds(
  org.Mm.eg.db,
  keys = res$ensembl_clean,
  column = "SYMBOL",
  keytype = "ENSEMBL",
  multiVals = "first"
)

## Save annotated results
out_path <- here("plots", "03_differential_expression", "DE_results_SRP092108_annotated.csv")
write.csv(res, out_path, row.names = FALSE)

## Quick sanity check
head(res[, c("ensembl", "symbol", "logFC", "adj.P.Val")], 15)

res <- read.csv(here("plots","03_differential_expression","DE_results_SRP092108_annotated.csv"))

## Decide direction: your coef was Tumor_vs_Normal
## So logFC > 0 means higher in Tumor; logFC < 0 means lower in Tumor.

top_up   <- subset(res, logFC > 0)[order(-subset(res, logFC > 0)$logFC), ][1:15, c("symbol","logFC","adj.P.Val")]
top_down <- subset(res, logFC < 0)[order(subset(res, logFC < 0)$logFC), ][1:15, c("symbol","logFC","adj.P.Val")]

top_up
top_down