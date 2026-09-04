# TFH-to-TR1 scCUT&Tag multiome analysis

Code accompanying the Master's Thesis **"Gene regulatory networks driving TFH-to-TR1 transdifferentiation using single-cell multiome and single-cell CUT&Tag"** by Enric Canut Zimmermann (Master's Degree in Health Data Science, 2026).

## Overview

This repository contains the computational workflow used to integrate single-cell transcriptomic data with single-cell CUT&Tag measurements of **BCL6**, **IRF4**, and **MAF** across the TFH-to-TR1 transdifferentiation trajectory.

The analysis focuses on four transcriptionally defined cellular states:

- TFH
- TR1.1
- TR1.2
- Foxp3+TR1.2

The main goals are to:

1. process and quality-control matched single-cell RNA and CUT&Tag data;
2. assign cells to established TFH-to-TR1 states by reference mapping;
3. validate state assignments using state-specific gene-expression signatures;
4. normalize and reduce the dimensionality of sparse CUT&Tag data;
5. construct a shared genomic peak reference for cross-TF quantification;
6. evaluate the robustness of state-level differential TF occupancy using pseudobulk sensitivity analyses and balanced resampling; and
7. generate the figures and supplementary tables reported in the thesis.

## Repository structure

A recommended structure is:

```text
tfh-tr1-sccuttag-multiome/
├── README.md
├── analysis/
│   ├── 01_preprocessing.Rmd
│   ├── 02_rna_annotation.Rmd
│   ├── 03_cuttag_consensus.Rmd
│   ├── 04_pseudobulk_sensitivity.Rmd
│   ├── 05_balanced_resampling.Rmd
│   └── 06_figures_tables.Rmd
├── config/
│   └── paths.example.R
├── data/
│   └── README.md
├── figures/
├── results/
│   ├── objects/
│   └── tables/
└── sessionInfo.txt
```

The current analysis was originally developed in a single exploratory R Markdown notebook. The repository version should separate stable thesis analyses from exploratory or abandoned analyses so that the public workflow reflects the final thesis conclusions.

## Analysis workflow

### 1. Multimodal preprocessing

TF-specific CUT&Tag peak calls and cell metadata are loaded and quantified using `Signac::FeatureMatrix()`. CUT&Tag and gene-expression barcodes are matched using the 10x Genomics ARC barcode whitelists, and matched modalities are stored in Seurat objects.

### 2. Quality control

RNA quality control is performed separately for the BCL6, IRF4, and MAF datasets using sample-specific thresholds for RNA counts, detected RNA features, and mitochondrial RNA percentage. CUT&Tag signal is tracked using peak-count and peak-feature metrics.

### 3. Transcriptomic state annotation

RNA data are normalized and reduced using PCA. Cell-state labels are transferred from an independently annotated reference atlas using `Seurat::FindTransferAnchors()` and `Seurat::TransferData()` with 30 principal components. Cells with a maximum prediction score below 0.5 are labeled `Undefined`.

State assignments are further assessed using module scores derived from established TFH, TR1.1, TR1.2, and Foxp3+TR1.2 gene signatures.

### 4. CUT&Tag normalization and dimensionality reduction

CUT&Tag count matrices are processed with TF-IDF normalization and latent semantic indexing using Signac. Very low-abundance genomic features are excluded using `FindTopFeatures(min.cutoff = "q5")`. The first LSI component is excluded from UMAP construction because it is strongly associated with sequencing depth.

### 5. Common genomic reference

Peak coordinates from the three TF datasets are merged into a non-redundant union. Regions wider than 2 kb are excluded, and BCL6, IRF4, and MAF fragments are re-quantified over the same genomic coordinates. A peak is retained in the final consensus set when it is detected in at least one cell in at least one TF dataset.

### 6. Pseudobulk sensitivity analysis

CUT&Tag counts are aggregated by transcription factor and transcriptomically defined cell state. Counts are normalized to CPM and pairwise log2 fold changes are calculated.

Because the data are sparse and there is no biological replication, peak-level differential occupancy is treated as an **exploratory robustness assessment**, not as a formal differential-binding test. Minimum raw-count thresholds of 1, 2, 5, 10, and 20 counts in both states are evaluated to determine how strongly the number of eligible and apparently differential peaks depends on signal support.

### 7. Balanced resampling

Balanced resampling is evaluated for the **BCL6 TFH-versus-TR1.1** comparison as a representative, relatively well-sampled contrast. In each of 100 iterations, equal numbers of cells are independently sampled from the two populations using 80% of the size of the smaller population.

Candidate regions are provisionally defined by:

- median |log2FC| > 1; and
- a >2-fold change in the same direction in at least 80% of resampling iterations.

Minimum cellular-support thresholds of three and five cells are compared. These analyses are used to evaluate robustness rather than to claim statistically validated differential binding.

## Data availability

Large sequencing files, fragment files, BAM files, and processed Seurat objects are **not intended to be committed directly to GitHub**. The analysis scripts expect these files to be available locally using the directory structure specified in the configuration file.

A minimal `data/README.md` should describe the expected input files and how they were generated without redistributing data that are subject to institutional, collaboration, or storage restrictions.

## Software

The workflow is implemented in R and primarily uses:

- Seurat
- Signac
- Matrix
- GenomicRanges
- EnsDb.Mmusculus.v79
- BSgenome.Mmusculus.UCSC.mm10
- dplyr
- tidyr
- purrr
- ggplot2
- patchwork
- qs

The exact package versions used for the final analysis should be recorded with:

```r
writeLines(capture.output(sessionInfo()), "sessionInfo.txt")
```

For stronger reproducibility, an `renv.lock` file can also be generated with `renv`.

## Reproducing the analysis

1. Clone the repository.
2. Create the expected local data directories or edit `config/paths.example.R` to point to the relevant files.
3. Install the required R/Bioconductor packages.
4. Run the numbered analysis scripts in order.
5. Generated figures and tables will be written to `figures/` and `results/`.

Because the raw sequencing data and large intermediate objects are not stored in the repository, the public repository documents and reproduces the computational workflow provided that the required input data are available locally.

## Author

**Enric Canut Zimmermann**  
Master's Degree in Health Data Science  
Barcelona, 2026
