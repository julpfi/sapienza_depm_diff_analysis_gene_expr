# config.R - global settings shared by all notebooks


# ---- Project -------------------------------------------------

project_specifier <- "TCGA-PRAD"
random_seed       <- 1019



# ---- Packages ----------------------------------------------------------

# All packages of the project
# Check installation in 01_data_preparation.Rmd
required_packages <- c("TCGAbiolinks", "SummarizedExperiment", "dplyr", "tibble",
                       "DESeq2", "ggplot2", "igraph")

# Check that packages are installed, then load them (used in notebooks 02+)
check_and_load_packages <- function(packages) {
  missing_packages <- packages[!sapply(packages, requireNamespace, quietly = TRUE)]
  if (length(missing_packages) > 0) {
    stop("Missing packages: ", paste(missing_packages, collapse = ", "),
         " -> run the packages chunk of 01_data_preparation.Rmd first")
  }
  invisible(lapply(packages, library, character.only = TRUE))
}



# ---- Folders and file paths -------------------------------------------------

# Notebooks live in the project root -> getwd() is the root when knitting
root_dir <- getwd()
data_dir <- file.path(root_dir, "data")      # not in git
target_download_dir <- file.path(data_dir, "GDCdata")   # raw GDC files
results_dir <- file.path(root_dir, "results")   # tables (small, in git)
image_dir <- file.path(root_dir, "images")    # figures for the report

# File names with project prefix, e.g. data_path("vst.rds") -> data/TCGA-PRAD_vst.rds
data_path <- function(name) file.path(data_dir,    paste0(project_specifier, "_", name))
results_path <- function(name) file.path(results_dir, paste0(project_specifier, "_", name))
image_path <- function(name) file.path(image_dir,   paste0(project_specifier, "_", name))



# ---- Analysis parameters ----------------------------------

# Task 2: DEGs
padj_thresh <- 0.01                 # adjusted p-value (FDR)
lfc_thresh <- log2(4) #or log2(3)   # |log2 fold change| 


# Task 3: co-expression networks
cor_method    <- "pearson"   # "pearson" or "spearman"
cor_threshold <- 0.7         # hard threshold on |rho|
hub_fraction  <- 0.05        # hubs = top 5% of nodes by degree



# ---- Colors ---------------------------------------------------------


# General palette
color_palette <- c(
  primary = "orange",
  secondary = "navy",
  tertiary = "tomato",
  neutral = "grey"
)


# Condition
condition_colors <- c(
  cancer = "orange",
  normal = "steelblue"
)

# DEG regulation (Task 2)
regulation_colors <- c(
  "Up-regulated"    = "firebrick",
  "Down-regulated"  = "steelblue",
  "Not Significant" = "grey"
)


# Hub types (Task 3)
hub_colors <- c(
  "cancer-only hub" = condition_colors[["cancer"]],
  "normal-only hub" = condition_colors[["normal"]],
  "common hub" = "limegreen",
  "no hub"= "grey"
)






# ---- ggplot theme ---------------------------------------------------------

theme_project <- function() {
  ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold"),
      legend.position = "top",
      panel.grid.minor = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(face = "bold")
    )
}

# Default theme for all ggplots (only if ggplot2 is already installed)
if (requireNamespace("ggplot2", quietly = TRUE)) {
  ggplot2::theme_set(theme_project())
}

# Save a ggplot as PDF to images (vector format for the report)
save_plot <- function(plot, name, width = 7, height = 5) {
  ggplot2::ggsave(image_path(paste0(name, ".pdf")), plot, width = width, height = height)
}