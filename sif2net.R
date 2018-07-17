library(tidyverse)
library(data.table)
library(igraph)

input = "Red10K_MET_HER2_val2.sif"

x = fread(input)
g = graph_from_data_frame(x, directed = FALSE)
E(g)$weight = x$V5
dafa = get.data.frame(g, "vertices")
dafa$id = seq_along(dafa$name)
head(dafa)
write.table(x = dafa, file = "diccionario_nodos.txt", quote = FALSE, sep = "\t", row.names = FALSE, col.names = TRUE)
write.graph(g, "g.net", "pajek")
