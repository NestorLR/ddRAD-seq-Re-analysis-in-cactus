# Load required libraries for SNP data handling, PCA, and visualization
library(vcfR)
library(adegenet)
library(ggplot2)
library(dplyr)
library(SNPRelate)

# Set working directory (adjust to your system)
setwd("/media/delil/ADATA_HD710_PRO/ddRAD-seq/results/SNP_Relate_IPYRAD/")

###### PCA with SNPRelate: Austrocactus ######

# Convert VCF file to GDS format (efficient storage for large SNP datasets)
# Only biallelic loci are retained for PCA
snpgdsVCF2GDS(
  "Austrocactus/vcf_data/filtered_Miss_MAF.vcf",
  "Austrocactus/vcf_data/Austrocactus_data3.gds",
  method = "biallelic.only"
)

# Open GDS file (data is accessed on demand, improving memory efficiency)
genofile <- snpgdsOpen("Austrocactus/vcf_data/Austrocactus_data3.gds")

# Perform PCA using SNPRelate
# autosome.only = FALSE allows inclusion of all loci (appropriate for non-model organisms)
pca <- snpgdsPCA(genofile, num.thread = 4, autosome.only = FALSE)

# Percentage of variance explained by each principal component
percent <- pca$varprop * 100

# Create a data frame with PCA scores
df <- data.frame(
  sample = pca$sample.id,
  PC1 = pca$eigenvect[, 1],
  PC2 = pca$eigenvect[, 2]
)

# ==============================
# ADD METADATA (SPECIES)
# ==============================

# Load population map linking samples to species
popmap <- read.table("../../stacks/popmap_Austrocactus.txt", stringsAsFactors = FALSE)
colnames(popmap) <- c("sample", "species")

# Merge PCA results with species information
df <- merge(df, popmap, by = "sample")

# Optional grouping (not used downstream, but kept for clarity)
df_grouped <- df %>%
  group_by(species)

# Filter species with at least 3 samples (useful for robust visualization/interpretation)
df_filtered <- df %>%
  group_by(species) %>%
  filter(n() >= 3)

# ==============================
# DEFINE COLOR PALETTE
# ==============================

cols <- c(
  "#e41a1c","#377eb8","#4daf4a","#CA5995","#ff7f00",
  "#ffff33","#a65628","#f781bf","#C44545","#66c2a5",
  "#fc8d62","#2F2FE4","#e78ac3","#a6d854","#5D1C6A",
  "#e5c494","#b3b3b3","#1b9e77","#546B41"
)

# ==============================
# PCA PLOT (ALL SAMPLES)
# ==============================

p <- ggplot(df, aes(PC1, PC2, fill = species, shape = species)) +
  geom_point(size = 4, color = "black", stroke = 0.5) +
  scale_fill_manual(values = cols) +
  scale_shape_manual(values = c(
    21,22,23,24,25,21,22,23,24,25,
    21,22,23,24,25,21,22,23,24
  )) +
  theme_classic() +
  labs(
    x = paste0("PC1 (", round(percent[1], 2), "%)"),
    y = paste0("PC2 (", round(percent[2], 2), "%)"),
    fill = "Species",
    shape = "Species"
  )

# Save PCA plot including all samples
ggsave("Austrocactus/PCA_Austrocactus.pdf", p, width = 12, height = 8)

# ==============================
# REMOVE OUTLIERS AND RE-PLOT
# ==============================

# Define outlier samples (identified a priori)
outliers <- c("ERR6064656", "ERR6064663")

# Remove outliers from dataset
df_clean <- df[!df$sample %in% outliers, ]

# Optional grouping after filtering
df_clean_grouped <- df_clean %>%
  group_by(species)

# Re-plot PCA without outliers
p_clean <- ggplot(df_clean, aes(PC1, PC2, fill = species, shape = species)) +
  geom_point(size = 4, color = "black", stroke = 0.5) +
  scale_fill_manual(values = cols) +
  scale_shape_manual(values = c(
    21,22,23,24,25,21,22,23,24,25,
    21,22,23,24,25,21,22,23,24
  )) +
  theme_classic() +
  labs(
    x = paste0("PC1 (", round(percent[1], 2), "%)"),
    y = paste0("PC2 (", round(percent[2], 2), "%)"),
    fill = "Species",
    shape = "Species"
  )

# Save PCA plot without outliers
ggsave("Austrocactus/Austrocactus_Preeliminar.pdf", p_clean, width = 12, height = 8)

# ==============================
# NOTES:
# ==============================
# - PCA is performed on genome-wide SNP data using SNPRelate.
# - Only biallelic SNPs are included to ensure compatibility with PCA assumptions.
# - Outlier removal is performed post hoc and should be justified biologically or technically.
# - The same variance explained (PC1, PC2) is retained after filtering for consistency,
#   although recalculating PCA after removing outliers may be preferable in some cases.
