# Load required libraries 
library(dplyr)
library(reshape2)
library(ggplot2)
library(tidyr)

# Set working directory
setwd("/media/delil/ADATA_HD710_PRO/ddRAD-seq/results/admixure/Austrocactus_Stacks/runs/")

# ==============================
# INPUT DATA
# ==============================

# Load ADMIXTURE Q-matrix (ancestry proportions)
Q <- read.table("data_filtered.3.rep1.Q")

# Load PLINK .fam file to retrieve sample order
fam <- read.table("../data.fam")
samples <- fam$V2

# Load population map (sample → species assignment)
popmap <- read.table("../../stacks/popmap.txt", stringsAsFactors = FALSE)
colnames(popmap) <- c("sample", "species")

# ==============================
# BUILD MAIN DATA FRAME
# ==============================

# Combine sample IDs with ancestry coefficients
df <- data.frame(sample = samples, Q)

# Merge with species metadata
df <- merge(df, popmap, by = "sample")

# Restore original sample order from the FAM file
df <- df[match(samples, df$sample), ]

# Identify columns corresponding to ancestry proportions (Q matrix)
Q_cols <- colnames(df)[grepl("^V", colnames(df))]

# ==============================
# MANUAL SPECIES ORDER
# ==============================

# Define desired plotting order for species
desired_species_order <- c(
  "AON","BER","IMPLE","DECO","DIAM","ELEG","FERRA",
  "HIBEhi","HIBEro",
  "PHILI","PRAE","SUBA","LONG","PAU","BREVI","NOBI","COX","COXcol","OCCI"
)

df$species <- factor(df$species, levels = desired_species_order)

# ==============================
# DEFINE DOMINANT CLUSTER
# ==============================

# Assign each individual to its dominant ancestry cluster
df$cluster <- apply(df[, Q_cols], 1, which.max)

# Store maximum ancestry proportion per individual
df$maxQ <- apply(df[, Q_cols], 1, max)

# ==============================
# FINAL ORDERING (CRITICAL STEP)
# ==============================

# Order individuals by species, then by cluster, then by ancestry proportion
df <- df %>%
  arrange(species, cluster, desc(maxQ))

# Fix factor levels to preserve plotting order
df$sample <- factor(df$sample, levels = df$sample)

# ==============================
# TRANSFORM TO LONG FORMAT
# ==============================

df_long <- df %>%
  pivot_longer(
    cols = starts_with("V"),
    names_to = "cluster_id",
    values_to = "ancestry"
  )

# ==============================
# ADMIXTURE BARPLOT
# ==============================

p <- ggplot(df_long, aes(x = sample, y = ancestry, fill = cluster_id)) +
  geom_bar(stat = "identity", width = 1) +
  facet_grid(~species, scales = "free_x", space = "free_x") +
  scale_fill_manual(values = c("#1b9e77", "#d95f02", "#7570b3")) +
  theme_classic() +
  labs(y = "Ancestry") +
  theme(
    axis.title.x = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    strip.background = element_blank(),
    strip.text = element_text(size = 7, angle = 45, face = "bold"),
    legend.position = "none"
  )

# Display plot
print(p)

# ==============================
# SAVE OUTPUT
# ==============================

ggsave("../Admixture_plot_K3.pdf", p, width = 12, height = 4)
ggsave("../Admixture_plot_K3.png", p, width = 12, height = 4)

# ==============================
# NOTES:
# ==============================
# - Individuals are ordered within species by their dominant ancestry cluster,
#   improving interpretability of admixture patterns.
# - The use of the original FAM order ensures consistency with upstream analyses.
# - Manual species ordering allows biologically meaningful arrangement (e.g., phylogenetic or geographic).
# - Colors should remain consistent across K values for comparability.
