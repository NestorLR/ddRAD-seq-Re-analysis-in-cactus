#!/bin/bash

# Objetivo: Determinar los parámetros que 
# 1. Maximiza loci útiles
# 2. reduce ruido
# 3. mejora compartición entre especies --> maximizar loci comparables entre especies

#Se realiza por cada ensamblado

for R in 0.3 0.5 0.7
do
  outdir=../stacks/1st_assembly/denovo_baseline/R_$R

  mkdir -p $outdir

  populations \
    -P ../stacks/1st_assembly/denovo_baseline \
    -M ../stacks/popmap.txt \
    -R $R \
    --vcf \
    --fstats \
    -O $outdir

done


# -r,--min-samples-per-pop [float] — minimum percentage of individuals in a population required to process a locus for that population.
# -R,--min-samples-overall [float] — minimum percentage of individuals across populations required to process a locus.
# --fstats — enable SNP and haplotype-based F statistics.
# --max-obs-het [float] — specify a maximum observed heterozygosity required to process a nucleotide site at a locus (applied to the metapopulation).
