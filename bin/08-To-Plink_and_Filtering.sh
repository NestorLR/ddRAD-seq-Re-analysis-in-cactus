#!/bin/bash

# Exit on error, undefined variables, or pipeline failures
set -euo pipefail

# ============================================
# Convert VCF to PLINK binary format
# ============================================
# --vcf             : input VCF file
# --allow-extra-chr : allows non-standard chromosome names (e.g., "chr1" assigned artificially)
# --make-bed        : outputs PLINK binary files (.bed, .bim, .fam)
# --out             : output prefix

plink \
  --vcf ../stacks/1s_assembly/denovo_baseline/final_dataset_R0.5/fixed_to_plink.vcf \
  --allow-extra-chr \
  --make-bed \
  --out ../admixture/data

# ============================================
# Apply SNP filtering
# ============================================
# --bfile : input PLINK binary dataset
# --maf   : remove SNPs with minor allele frequency < 0.05
# --geno  : remove SNPs with missing genotype rate > 50%
# --make-bed : output filtered dataset in PLINK binary format

plink \
  --bfile ../admixture/data \
  --maf 0.05 \
  --geno 0.5 \
  --make-bed \
  --out ../admixture/data_filtered

# ============================================
# Notes:
# ============================================
# - The MAF filter (0.05) removes rare variants that may introduce noise
#   in population structure analyses such as ADMIXTURE.
# - The missing data filter (--geno 0.5) is relatively permissive; stricter
#   thresholds (e.g., 0.1 or 0.2) may be used depending on data quality.
# - Filtering is performed after conversion to PLINK format for efficiency.
# - Ensure consistency between datasets if multiple species or pipelines are compared.
