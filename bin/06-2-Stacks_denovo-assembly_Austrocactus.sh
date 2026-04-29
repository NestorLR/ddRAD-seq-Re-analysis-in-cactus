#!/bin/bash

# Exit on error, undefined variables, or pipeline failures
set -euo pipefail

# ============================================
# De novo assembly of RAD-seq data (Stacks)
# ============================================
# This step runs the de novo pipeline to assemble loci and call SNPs without a reference genome.

denovo_map.pl \
  --samples ../stacks/Austrocactus/Process_radtags/ \
  --popmap ../stacks/popmap_Austrocactus.txt \
  -T 8 \                         # number of threads
  -m 3 \                         # minimum depth of coverage to create a stack
  -M 2 \                         # maximum mismatches allowed between stacks (within individuals)
  -n 2 \                         # maximum mismatches allowed between loci (across individuals)
  -X "ustacks: --force-diff-len" \  # allow loci of different lengths (useful for indel variation)
  -o ../stacks/Austrocactus/assembly/denovo2_M2_n2

# ============================================
# Notes:
# ============================================
# - This configuration represents a commonly used baseline parameter set for RAD-seq data.
# - The parameters (-M, -n) influence locus clustering stringency and can affect SNP recovery.
# - The '-m 3' threshold helps reduce sequencing errors by requiring a minimum read depth.
# - The option '--force-diff-len' allows inclusion of loci with indel variation,
#   which may be important for non-model organisms.
# - Parameter optimization (e.g., testing multiple M/n combinations) is recommended
#   to assess robustness of downstream population genomic inferences.
 
