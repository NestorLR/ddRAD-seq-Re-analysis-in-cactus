#!/bin/bash

# Exit immediately if a command fails, treat unset variables as errors,
# and ensure failures in pipelines are detected
set -euo pipefail

# Navigate to the IQ-TREE working directory
cd ../results/iqtree/

# Define input directory containing .phy alignments
INPUT="$(pwd)/input"

# Loop over all PHYLIP files in the input directory
for file in "$INPUT"/*.phy; do
    
    # Extract base filename (without extension) to use as a prefix and directory name
    name=$(basename "$file" .phy)
    
    # Create a dedicated output directory for each alignment
    mkdir -p "$name"
    cd "$name"

    # -s     : input alignment file
    # -m MFP : ModelFinder Plus (automatically selects the best-fit substitution model)
    # -bb    : ultrafast bootstrap approximation
    # -alrt  : SH-aLRT branch test
    # -nt    : automatic detection of available CPU cores
    # -pre   : prefix for all output files
    
    iqtree2 \
        -s "$file" \
        -m MFP \
        -bb 1000 \
        -alrt 1000 \
        -nt AUTO \
        -pre "$name"

    # Return to the parent directory before processing the next file
    cd ..
done

# Notes:
# - Each alignment is analyzed independently in its own directory.
# - Output files are prefixed with the alignment name for clarity.
# - The combination of ultrafast bootstrap and SH-aLRT provides complementary
#   measures of branch support.
