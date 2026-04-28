#!/bin/bash

# ===============================
# ddRAD Quality Control Pipeline
# ===============================

# Exit if any command fails
set -e

# Define directories
RAW_DIR="../data/raw-data/PRJEB39114"
FASTQC_DIR="../data/processed/fastqc/PRJEB39114"
MULTIQC_DIR="../data/processed/multiqc/PRJEB39114"

# Create output directories if they don't exist
mkdir -p "$FASTQC_DIR"
mkdir -p "$MULTIQC_DIR"

echo "======================================"
echo "Running FastQC on all FASTQ files..."
echo "======================================"

# Run FastQC on all gzipped FASTQ files
fastqc "$RAW_DIR"/*.fastq.gz -o "$FASTQC_DIR" -t 4

echo "======================================"
echo "Running MultiQC..."
echo "======================================"

# Aggregate all FastQC reports
multiqc "$FASTQC_DIR" -o "$MULTIQC_DIR"

echo "======================================"
echo "Quality control completed successfully."
echo "Results:"
echo "FastQC reports:  $FASTQC_DIR"
echo "MultiQC report:  $MULTIQC_DIR"
echo "======================================"
