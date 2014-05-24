
saveData <- function (name, ...) {
    save(..., file=file.path(TIDY_PATH, paste0(name, ".Rdata")))
}

# Denormalize one column into another by matching and extracting a regular expression capture group.
factorsFromRegex <- function (regex, col, subex="\\1", missing=NA) {
    factor(ifelse(grepl(regex, col), gsub(regex, subex, col), missing))
}

# Load both train and test, then concatenate them.
loadData <- function (type, ...) {
    train <- read.table(file.path(HAR_DIR, "train", paste0(type, "_train.txt")), ...)
    test <- read.table(file.path(HAR_DIR, "test", paste0(type, "_test.txt")), ...)
    rbind(train, test) # concatenate
}
