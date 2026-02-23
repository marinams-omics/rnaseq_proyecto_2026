## Load required packages first
library("here")         ## for using relative paths across the whole project
library("sessioninfo")  ## for reproducibility information
library("recount3")     ## for accessing recount3 data

## Define & create output directories
dir_rdata <- here("processed-data", "01_read_data_to_r")
dir.create(dir_rdata, showWarnings = FALSE, recursive = TRUE)

## Read in data (recount3): SRA SRP092108 (mouse) gene-level counts
message("Fetching recount3 project table (mouse)...")
mouse_projects <- available_projects(organism = "mouse")

## Select the SRP092108 row
proj_info <- subset(
  mouse_projects,
  project == "SRP092108" & project_type == "data_sources"
)

## If multiple rows match, keep the first (rare but possible)
if (nrow(proj_info) != 1) {
  message("proj_info has ", nrow(proj_info), " rows; using the first row.")
  proj_info <- proj_info[1, , drop = FALSE]
}

message("Downloading SRP092108 (gene-level) RSE...")
rse <- create_rse(proj_info)

message("Download complete.")
message("Dimensions (genes x samples): ", nrow(rse), " x ", ncol(rse))

## Convert coverage counts -> read counts (recommended for DE methods)
message("Converting to read counts with compute_read_counts()...")
assay(rse, "counts") <- compute_read_counts(rse)

## Expand SRA metadata into sra_attribute_* columns
message("Expanding SRA attributes...")
rse <- expand_sra_attributes(rse)

## Quick sanity check of available attributes
attrs <- grep("^sra_attribute", colnames(colData(rse)), value = TRUE)
message("Available sra_attribute_* columns: ", paste(attrs, collapse = ", "))

## Define clean grouping variable (for DE later)
## Define clean grouping variable
rse$group <- factor(colData(rse)$sra_attribute.genotype)

table(rse$group)

## Optional: rename levels for clarity
levels(rse$group) <- c("Normal", "Tumor")

table(rse$group)

## Save outputs for later steps
saveRDS(rse, file = file.path(dir_rdata, "rse_gene_srp092108.rds"))

write.csv(
  as.data.frame(colData(rse)),
  file = file.path(dir_rdata, "coldata_srp092108.csv"),
  row.names = TRUE
)

message("Saved outputs to: ", dir_rdata)

## Reproducibility information
print("Reproducibility information:")
Sys.time()
proc.time()
options(width = 120) ## Makes it easier to read later
session_info()