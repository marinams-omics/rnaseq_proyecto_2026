library("here")
library("SummarizedExperiment")
library("edgeR")
library("limma")
library("pheatmap")

dir_plots <- here("plots", "03_differential_expression")
dir.create(dir_plots, showWarnings = FALSE, recursive = TRUE)

rse <- readRDS(here("processed-data", "01_read_data_to_r", "rse_gene_srp092108.rds"))

counts <- assay(rse, "counts")
group <- rse$group

## Filtering
keep <- filterByExpr(counts, group = group)
counts_f <- counts[keep, ]

## DGEList + normalization
y <- DGEList(counts = counts_f, group = group)
y <- calcNormFactors(y)

## Design matrix
design <- model.matrix(~ group)
colnames(design) <- c("Intercept", "Tumor_vs_Normal")

## Voom transformation
v <- voom(y, design, plot = FALSE)

## Fit linear model
fit <- lmFit(v, design)
fit <- eBayes(fit)

## Extract DE results
results <- topTable(fit, coef = "Tumor_vs_Normal", number = Inf)
write.csv(results, file = file.path(dir_plots, "DE_results_SRP092108.csv"))

## Volcano Plot
pdf(file = file.path(dir_plots, "Volcano_SRP092108.pdf"), width = 7, height = 6)

plot(
  results$logFC,
  -log10(results$P.Value),
  pch = 16,
  cex = 0.5,
  xlab = "log2 Fold Change",
  ylab = "-log10(p-value)",
  main = "Volcano: Tumor vs Normal"
)

abline(h = -log10(0.05), col = "red", lty = 2)
abline(v = c(-1, 1), col = "blue", lty = 2)

dev.off()

## Heatmap of top 50 DE genes
top50 <- rownames(results)[1:50]
mat <- v$E[top50, ]

annotation <- data.frame(Group = group)
rownames(annotation) <- colnames(mat)

pdf(file = file.path(dir_plots, "Heatmap_Top50_SRP092108.pdf"), width = 8, height = 10)
pheatmap(
  mat,
  annotation_col = annotation,
  show_rownames = FALSE,
  scale = "row"
)
dev.off()

message("DE analysis complete.")