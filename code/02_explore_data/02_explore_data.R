library("here")
library("SummarizedExperiment")
library("edgeR")

## output dirs
dir_plots <- here("plots", "02_explore_data")
dir.create(dir_plots, showWarnings = FALSE, recursive = TRUE)

## load data
rse <- readRDS(here("processed-data", "01_read_data_to_r", "rse_gene_srp092108.rds"))

## extract counts + group
counts <- assay(rse, "counts")
group <- rse$group
stopifnot(!is.null(group))

## basic filtering (keep genes expressed in a reasonable number of samples)
keep <- filterByExpr(counts, group = group)
counts_f <- counts[keep, ]

## log-CPM transform for exploration
y <- DGEList(counts = counts_f, group = group)
y <- calcNormFactors(y)
logcpm <- cpm(y, log = TRUE, prior.count = 1)

## PCA
pca <- prcomp(t(logcpm), scale. = FALSE)

## plot PC1 vs PC2
pdf(file = file.path(dir_plots, "PCA_logCPM_SRP092108.pdf"), width = 7, height = 6)
plot(
  pca$x[, 1], pca$x[, 2],
  xlab = paste0("PC1 (", round(100 * summary(pca)$importance[2, 1], 1), "%)"),
  ylab = paste0("PC2 (", round(100 * summary(pca)$importance[2, 2], 1), "%)"),
  main = "SRP092108 (mouse): Normal vs Tumor",
  pch = 16,
  col = as.integer(group)
)
legend("topright", legend = levels(group), pch = 16, col = seq_along(levels(group)))
dev.off()

message("Saved PCA plot to: ", file.path(dir_plots, "PCA_logCPM_SRP092108.pdf"))