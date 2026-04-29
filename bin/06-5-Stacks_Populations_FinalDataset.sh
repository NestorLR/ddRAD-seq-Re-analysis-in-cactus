#!/bin/bash

populations \
    -P ../stacks/1st_assembly/denovo_baseline \
    -M ../stacks/popmap.txt \
    -R 0.5 \
    --structure \
    --fasta-loci \
    --vcf \
    --fstats \
    -O ../stacks/1st_assembly/denovo_baseline/final_dataset_R0.5
