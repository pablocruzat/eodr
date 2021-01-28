library(readr)
library(RSQLite)
library(usethis)
library(dplyr)
finp <- list.files("data-raw", pattern = "\\.tsv", full.names = T, recursive = T)
#parto con la primera tabla
d <- read_delim(finp[1], delim = "\t")
n <- gsub('.*/', "", finp)
n <- gsub('_|[0-9]','', n)
n <- tolower(gsub('\\.tsv','',n))

try(dir.create('inst'))
try(dir.create('inst/extdata'))
con <- dbConnect(SQLite(), "data-raw/eod2017.sqlite")

for (i in seq_along(finp)) {
  d <- read_delim(finp[i], delim = '\\t')
  copy_to(con, d, n[i], temporary = FALSE)
}

dbListTables(con)
dbDisconnect(con)
