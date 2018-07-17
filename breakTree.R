library(tidyverse)
library(data.table)
library(igraph)

dict.path  = "diccionario_nodos.txt" 
tree.path = "g.tree"
outpath   = "listasComunidades/"

#read dictionary and tree
dafa = fread(dict.path)

tri = read.table(file = tree.path)
tri = as.data.table(tri)
tri
tri$gene = dafa$name[match(tri$V4, table = dafa$id)]

#pad tri to have unique five-level code
q = as.character(tri$V1)
qq = strsplit(q, ":")
qqq = lapply(X = qq, FUN = function(i){
  if(length(i)==2){i[3:5] = NA}
  if(length(i)==2){i[3:5] = NA}
  if(length(i)==3){i[4:5] = NA}
  if(length(i)==4){i[5] = NA}
  return(i)
})
qqqq = sapply(X = qqq, FUN = function(i){
  pp = paste(i, collapse = ":")
  return(pp)
})
tri$V1 = qqqq

#break five level codes into different columns
tri = tidyr::separate(data = tri, 
                col = "V1", 
                sep = ":", 
                into = c("L1", "L2", "L3", "L4", "L5"),
                remove = FALSE,
                fill = "right"
                )

#treat NA as NA proper

tri[tri=="NA"]=NA

#PL 1:5 are padded modular levels

tri$PL1 = str_pad(string = tri$L1, width = 3, side = "left", pad = 0)
tri$PL2 = str_pad(string = tri$L2, width = 3, side = "left", pad = 0)
tri$PL3 = str_pad(string = tri$L3, width = 3, side = "left", pad = 0)
tri$PL4 = str_pad(string = tri$L4, width = 3, side = "left", pad = 0)


#PL 12, 123, and 1234 are concatenated padded levels
tri[,PL12:= paste0(PL1, PL2)]
tri[,PL123:= paste0(PL1, PL2, PL3)]
tri[,PL1234:= paste0(PL1, PL2, PL3, PL4)]

#write modified tree
fwrite(tri, "moddified.g.tree")

#Make lists of community memberships 

#Modular Level 1 Lv1


Lv1 = lapply(X = unique(tri$PL1), function(i){
  tri[PL1==i]$gene
})
names(Lv1) = unique(tri$PL1)

#Level 2
temp.dt = as.data.table(filter(tri, !is.na(L3)))

Lv2 = lapply(X = unique(temp.dt$PL12), function(i){
  temp.dt[PL12==i]$gene
})
names(Lv2) = unique(temp.dt$PL12)

#Level 3 
temp.dt = as.data.table(filter(tri, !is.na(L4)))
tempy = grep(pattern = "NA", x = unique(temp.dt$PL123), value = TRUE, invert = TRUE)
Lv3 = lapply(X = tempy, function(i){
  temp.dt[PL123==i]$gene
})
names(Lv3) = tempy

#Level 4
temp.dt = as.data.table(filter(tri, !is.na(L5)))
tempy = grep(pattern = "NA", x = unique(temp.dt$PL1234), value = TRUE, invert = TRUE)
Lv4 = lapply(X = tempy, function(i){
  temp.dt[PL1234==i]$gene
})
names(Lv4) = tempy

#Write out communities

#dir.create(path = "Paper/respuesta/listasComunidades")
#dir.create(path = "Paper/respuesta/listasComunidades/Level1")
#dir.create(path = "Paper/respuesta/listasComunidades/Level2")
#dir.create(path = "Paper/respuesta/listasComunidades/Level3")
#dir.create(path = "Paper/respuesta/listasComunidades/Level4")

sapply(X = names(Lv1), FUN = function(i){
  outname =  paste0(outpath, "Level1/", i, ".txt")
  write_lines(Lv1[[i]], outname)
  return(print(outname))
})

sapply(X = names(Lv2), FUN = function(i){
  outname =  paste0(outpath, "Level2/", i, ".txt")
  write_lines(Lv2[[i]], outname)
  return(print(outname))
})

sapply(X = names(Lv3), FUN = function(i){
  outname =  paste0(outpath, "Level3/", i, ".txt")
  write_lines(Lv3[[i]], outname)
  return(print(outname))
})

sapply(X = names(Lv4), FUN = function(i){
  outname =  paste0(outpath, "Level4/", i, ".txt")
  write_lines(Lv4[[i]], outname)
  return(print(outname))
})

#tablas descriptoras


descriptores_Level1 = data.frame(HighPageRank_gene = sapply(Lv1, FUN = function(i){i[1]}),
                                 numberOfgenes     = sapply(Lv1, length)
)
descriptores_Level2 = data.frame(HighPageRank_gene = sapply(Lv2, FUN = function(i){i[1]}),
                                 numberOfgenes     = sapply(Lv2, length)
)

descriptores_Level3 = data.frame(HighPageRank_gene = sapply(Lv3, FUN = function(i){i[1]}),
                                 numberOfgenes     = sapply(Lv3, length)
)

descriptores_Level4 = data.frame(HighPageRank_gene = sapply(Lv4, FUN = function(i){i[1]}),
                                 numberOfgenes     = sapply(Lv4, length)
)

write.table(x = descriptores_Level1, file = "listasComunidades/desciptores_Level1.txt", quote = FALSE, sep = "\t", row.names = TRUE, col.names = NA)
write.table(x = descriptores_Level2, file = "listasComunidades/desciptores_Level2.txt", quote = FALSE, sep = "\t", row.names = TRUE, col.names = NA)
write.table(x = descriptores_Level3, file = "Paper/respuesta/listasComunidades/desciptores_Level3.txt", quote = FALSE, sep = "\t", row.names = TRUE, col.names = NA)
write.table(x = descriptores_Level4, file = "Paper/respuesta/listasComunidades/desciptores_Level4.txt", quote = FALSE, sep = "\t", row.names = TRUE, col.names = NA)

