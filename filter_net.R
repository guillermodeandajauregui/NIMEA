library(data.table)
library(tidyverse)
library(argparser)

p <- arg_parser()
p <- add_argument(p, "input", help="input file")
p <- add_argument(p, "output", help="output file")
p <- add_argument(p, "n", help="number of edges to keep")

x = fread(p$input)
y = x[1:p$n, ]

fwrite(y, file = p$output, col.names = TRUE, row.names = FALSE, sep ="\t", quote = FALSE)
