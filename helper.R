
saveData <- function (name, ...) {
    save(..., file=file.path(TIDY_PATH, paste0(name, ".Rdata")))
}

factorsFromRegex <- function (regex, col, subex="\\1", missing=NA) {
    factor(ifelse(grepl(regex, col), gsub(regex, subex, col), missing))
}
