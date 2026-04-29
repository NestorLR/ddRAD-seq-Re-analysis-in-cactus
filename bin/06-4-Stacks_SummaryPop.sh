#!/bin/bash

BASE=../stacks/1st_assembly/denovo_baseline
OUTFILE=../stacks/1st_assembly/denovo_baseline/summary_R_metrics.tsv

# encabezado
echo -e "R\tSNPs\tLoci\tLoci_N>=5\tLoci_N>=8" > $OUTFILE

for R in 0.3 0.5 0.7
do
  dir=$BASE/R_$R

  echo "Procesando R=$R..."

  # SNPs
  snps=$(grep -vc "^#" $dir/populations.snps.vcf)

  # Loci únicos
  loci=$(awk '!/^#/ {print $1}' $dir/populations.sumstats.tsv | sort -u | wc -l)

  # Loci con N >= 5
  loci5=$(awk '!/^#/ && $8 >= 5 {print $1}' $dir/populations.sumstats.tsv | sort -u | wc -l)

  # Loci con N >= 8
  loci8=$(awk '!/^#/ && $8 >= 8 {print $1}' $dir/populations.sumstats.tsv | sort -u | wc -l)

  # guardar
  echo -e "$R\t$snps\t$loci\t$loci5\t$loci8" >> $OUTFILE

done
