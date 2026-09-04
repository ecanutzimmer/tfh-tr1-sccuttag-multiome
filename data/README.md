# Data directory

The sequencing data and large processed single-cell objects used in this project are not stored in the GitHub repository.

Expected local inputs include, for each BCL6, IRF4, and MAF experiment:

- permissive MACS2 narrowPeak files;
- CUT&Tag `fragments.tsv.gz` files;
- selected-cell metadata containing cell barcodes;
- matched 10x Genomics gene-expression matrices;
- 10x ARC ATAC/GEX barcode whitelists; and
- the annotated reference atlas used for RNA label transfer.

The analysis scripts use relative paths under `data/`. If your files are stored elsewhere, copy `config/paths.example.R` to `config/paths.R` and edit the paths locally.

Large sequencing files (BAM/BigWig files, fragment files, `.qs` objects, or `.rds`) are excluded.