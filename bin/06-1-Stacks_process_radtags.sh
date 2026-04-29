#!/bin/bash

# Exit on error, undefined variables, or pipeline failures
set -euo pipefail

# ============================================
# Quality filtering of demultiplexed RAD-seq reads
# ============================================
# This is the first  step in Stacks. It cleans raw reads prior to downstream assembly.

process_radtags \
  -p ../data/raw-data/Eulychnia \
  -o ../stacks/Eulychnia/Process_radtags_noenz \
  --threads 5 \
  -e PstI \  
  -c \          # remove reads with uncalled bases
  -q \          # perform quality filtering using a sliding window
  -r            # rescue barcodes and RAD-tags when possible

# ============================================
# Notes:
# ============================================
# - The input directory (-p) should contain demultiplexed FASTQ files.
# - The '-r' option attempts to recover reads with minor barcode or RAD-tag errors.
# - This step is critical for reducing sequencing errors prior to SNP calling.
