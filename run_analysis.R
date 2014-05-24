#!/opt/local/bin/Rscript
# run_analysis.R by Rick Osborne

# Settings: Change these to suit your needs
DATA_URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
DATA_DIR <- "data-src"
ZIP_PATH <- file.path(DATA_DIR, "uci-har-dataset.zip")
HAR_DIR <- file.path(DATA_DIR, "UCI HAR Dataset")
TIDY_PATH <- "data-tidy"
DOWNLOAD_METHOD <- "curl"
# You should not need to change anything below here.

# Download the data if needed
if (!file.exists(DATA_DIR)) dir.create(DATA_DIR)
if (!file.exists(ZIP_PATH)) download.file(DATA_URL, ZIP_PATH, DOWNLOAD_METHOD)
if (!file.exists(HAR_DIR)) unzip(ZIP_PATH, exdir=DATA_DIR)
if (!file.exists(TIDY_PATH)) dir.create(TIDY_PATH)

# Load biocLite for hdf5
# Failed attempt: rhdf5 does not save factor names, only ints.
#if (!require(rhdf5, quietly=TRUE)) {
#    message("Installing rhdf5 via biocLite")
#    source("http://bioconductor.org/biocLite.R")
#    biocLite("rhdf5")
#}
#library(rhdf5)
#if (!file.exists(TIDY_PATH)) h5createFile(TIDY_PATH)

# Activity Labels
activityLabels <- read.table(file.path(HAR_DIR, "activity_labels.txt"), sep=" ", col.names=c("id", "label"))
# h5write(activityLabels, TIDY_PATH, "labels", write.attributes=TRUE)
save(activityLabels, file=file.path(TIDY_PATH, "activity-labels.RData"))

# Features
features <- read.table(file.path(HAR_DIR, "features.txt"), sep=" ", col.names=c("id", "feature"))
features$axis <- factor(ifelse(grepl("-[XYZ]", features$feature), gsub("^.+-([XYZ],[XYZ]|[XYZ]).*$", "\\1", features$feature), NA))
features$func <- factor(ifelse(grepl("\\b(\\w+)\\(", features$feature), gsub("^.*\\b(\\w+)\\(.*$", "\\1", features$feature), NA))
features$signal <- factor(ifelse(grepl("^\\w+-", features$feature), gsub("^(\\w+)-.*$", "\\1", features$feature), NA))
features$domain <- factor(ifelse(substr(features$signal, 1, 1) == "t", "time", ifelse(substr(features$signal, 1, 1) == "f", "frequency", NA)))
# h5write(features, TIDY_PATH, "features", write.attributes=TRUE)
save(features, file=file.path(TIDY_PATH, "features.RData"))
