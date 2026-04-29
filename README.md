# ddRAD-seq re-analysis in cactus

This repository contains the re-analysis of ddRAD-seq data from the phylogenetic studies of:

* **Böhnert *et al.* (2025)** – *Systematic and taxonomic revision of the genus Austrocactus (Cactaceae) based on morphology and genome-wide SNP data*
* **Merklinger *et al.* (2021)** – *Quaternary diversification of a columnar cactus in the driest place on Earth*

## Data availability

Raw ddRAD-seq data were obtained from the [European Nucleotide Archive (ENA)](https://www.ebi.ac.uk/ena/browser/home) under the BioProjects:

* PRJEB79940
* PRJEB39114

---

## Experimental design

* **Library type:** double-digest RAD-seq (ddRAD-seq)
* **Restriction enzymes:** PstI (CTGCA/G) and MspI (C/CGG)
* **Sequencing platform:** Illumina NextSeq 500/550 v2
* **Read type:** single-end (1 × 75 bp)

---

## Biological sampling

* **Total samples:** 89

  * 42 from PRJEB79940
  * 47 from PRJEB39114

* **Taxa:**

  * 46 samples of *Austrocactus*
  * 40 samples of *Eulychnia*
  * 3 samples of *Corryocactus* (outgroup)

---

## Project structure

```bash
ddRAD-seq/
│
├── bin/                # Bash scripts and pipelines
├── data/               # Data directories (raw data NOT tracked)
│   ├── raw-data/       # Raw FASTQ files (ignored by Git)
│   ├── processed/      # Quality-filtered reads
│   ├── ipyrad/         # Assembly outputs (ipyrad, ignored by Git)
│   └── stacks/         # Assembly outputs (Stacks, ignored by Git)
│
├── metadata/           # Sample metadata and population information
│
├── results/            # Analysis outputs
│   ├── admixture/
│   ├── iqtree/
│   ├── SNPRelate_ipyrad/
│   ├── SNPRelate_stacks/
│   └── tetrad/
│
├── notebooks/          # Jupyter notebooks (ipyrad workflow)
└── README.md
```

---

## Workflow overview

This repository includes:

* A **Jupyter Notebook** describing the full *ipyrad* pipeline:

  * assembly of ddRAD-seq data
  * SNP filtering
  * downstream analyses (phylogenetic inference and clustering)

* A set of **Bash scripts** implementing an alternative pipeline using *Stacks*. In addition, a set of **Bash adn R scripts** for phylogenetic and clustering analysis is provided. 

---

## Software

Main tools used in this analysis:

* ipyrad
* Stacks
* IQ-TREE
* ADMIXTURE
* SNPRelate (R)

---

## Notes

* Raw sequencing data are **not stored in this repository** due to size limitations.
* All analyses can be reproduced from ENA accessions and provided scripts.

---

## Author

Néstor Edwin López Ruiz
PhD student – UNAM
