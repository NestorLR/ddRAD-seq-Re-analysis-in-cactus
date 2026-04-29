#!/bin/bash

# Exit on error, undefined variables, or pipeline failures
set -euo pipefail

# ============================================
# ADMIXTURE runs across multiple K values
# ============================================
# This script performs ADMIXTURE analyses for K = 1–8,
# with 5 independent replicates per K to assess convergence.

# Loop over the number of ancestral populations (K)
for K in {1..8}; do

  # Loop over replicate runs
  for rep in {1..5}; do

    # Run ADMIXTURE with:
    # --cv : enable cross-validation to estimate optimal K
    # -j8  : use 8 CPU threads
    # Input: PLINK binary file (.bed)
    #
    # Output:
    # - log file with CV error
    # - Q matrix (individual ancestry proportions)
    # - P matrix (allele frequencies per cluster)
    admixture --cv -j8 ../admixture/data_filtered.bed "$K" \
      | tee "log_K${K}_rep${rep}.out"

    # Rename output files to retain replicate information
    # This prevents overwriting results across runs
    mv "data_filtered.${K}.Q" "data_filtered.${K}.rep${rep}.Q"
    mv "data_filtered.${K}.P" "data_filtered.${K}.rep${rep}.P"

  done
done

# ============================================
# Notes:
# ============================================
# - Multiple replicates per K are essential because ADMIXTURE uses
#   a stochastic optimization algorithm that may converge to local optima.
# - Cross-validation (CV) error values can be extracted from log files
#   to determine the most likely number of clusters (K).
# - Consistent labeling of output files facilitates downstream analyses
#   (e.g., CLUMPAK, pong, or custom scripts).
