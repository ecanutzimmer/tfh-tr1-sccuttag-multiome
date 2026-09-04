# Personal local path configuration for tfh-tr1-sccuttag-multiome

project_data <- file.path("data", "sp20_21")
ct_root <- file.path(project_data, "relaxed", "scCT")
rna_root <- file.path(project_data, "relaxed", "rna")
reference_atlas_path <- file.path("data", "ctls_only_obj_260126.qs")

samples <- c("Bcl6", "Irf4", "Maf")

sample_dirs <- setNames(file.path(ct_root, samples), samples)
rna_dirs <- setNames(file.path(rna_root, samples), samples)
