#!/bin/bash

#This script downloads raw data from SRA database

ACCESSIONS_FILE="../metadata/PRJEB39114_AccesionList.txt"
OUTPUT_DIR="../data/raw-data/PRJEB39114"

mkdir -p $OUTPUT_DIR

mapfile -t SRA_IDS < "$ACCESSIONS_FILE"

for SRA_ID in "${SRA_IDS[@]}"
do
    echo "Downloading $SRA_ID"

    # download .sra
    prefetch $SRA_ID --output-directory $OUTPUT_DIR

    # convert to fastq
    fasterq-dump $OUTPUT_DIR/$SRA_ID -O $OUTPUT_DIR

    # compress
    gzip $OUTPUT_DIR/*.fastq

    echo "Finished $SRA_ID"
done

