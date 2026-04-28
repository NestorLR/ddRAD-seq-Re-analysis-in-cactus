
#!/bin/bash

# ============================================
# Standardizing VCF chromosome field for PLINK
# ============================================
# Many downstream tools (e.g., PLINK, ADMIXTURE) require a valid chromosome
# identifier. For de novo assemblies lacking chromosome information,
# we assign all loci to a dummy chromosome ("chr1").

# ============================================
# Austrocactus dataset (STACKS output)
# ============================================

# Replace the first column (CHROM) with "chr1" while preserving header lines
awk 'BEGIN {OFS="\t"}
     /^#/ {print; next}
     {$1="chr1"; print}' \
../stacks/1s_assembly/denovo_baseline/final_dataset_R0.5/populations.snps.vcf \
> ../stacks/1s_assembly/denovo_baseline/final_dataset_R0.5/fixed_to_plink.vcf

# ============================================
# Eulychnia dataset (ipyrad output)
# ============================================

# Apply the same transformation to ensure consistency across datasets
awk 'BEGIN {OFS="\t"}
     /^#/ {print; next}
     {$1="chr1"; print}' \
/media/delil/ADATA_HD710_PRO/ddRAD-seq/results/SNP_Relate_IPYRAD/Eulychnia/vcf_data/pops70miss_clust85.filtered.recoded.vcf \
> /media/delil/ADATA_HD710_PRO/ddRAD-seq/results/admixture/Eulychnia_ipyrad/fixed_to_plink.vcf

# ============================================
# Notes:
# ============================================
# - This step ensures compatibility with PLINK and ADMIXTURE, which may fail
#   when chromosome identifiers are missing or non-standard.
# - Assigning all SNPs to a single artificial chromosome does not affect
#   allele frequency-based analyses (e.g., PCA, ADMIXTURE), but it is not
#   appropriate for analyses relying on linkage or genomic position.
# - The script preserves all header lines (starting with '#') unchanged.
