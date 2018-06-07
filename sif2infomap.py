####AUTHOR: SERGIO ANTONIO ALCALA CORONA

import sys
import networkx as nx

path = sys.argv[1]
sep = sys.argv[2]
form = sys.argv[3]
diccionario = {}
diccionarioB = {}
genesDIC = []
G = nx.Graph()

name = path.split('.')
output = name[0]+'.net'
SALIDA = open(output,"w")

if (sep == "cma"):
  sep = ","
elif (sep == "tab"):
  sep = "\t"
elif (sep == "spa"):
  sep = " "

interacciones = open(path).readlines()

k = 1
tmp="---"
for i in interacciones:
    genes  = i.split(sep)

    a=genes[0].strip()
    b=genes[1].strip()
    c=genes[2].strip()

    if (form == "nIn"):
      if (genes[0].strip() not in genesDIC): genesDIC.append(genes[0].strip())
      if (genes[2].strip() not in genesDIC): genesDIC.append(genes[2].strip())

    elif (sep == "nnI"):
      if (genes[0].strip() not in genesDIC): genesDIC.append(genes[0].strip())
      if (genes[1].strip() not in genesDIC): genesDIC.append(genes[1].strip())

SALIDA.write("%s %s \n" % ("*Vertices", len(genesDIC)))


i = 1
for n in genesDIC:
    diccionario[n] = i
    diccionarioB[i] = n
    SALIDA.write('%s "%s" \n' % (i,n))
    i+=1


for i in interacciones:
    campos  = i.split(sep)

    a=campos[0].strip()
    b=campos[1].strip()
    c=campos[2].strip()

    if (form == "nIn"):
      if (b == "pp"):
	b = 1
      else:
	b=float(b)

      if (a in diccionario and c in diccionario) and (diccionario[a] != diccionario[c]):
	if ((G.has_edge(diccionario[a],diccionario[c]) == False) and (G.has_edge(diccionario[c],diccionario[a]) == False)):
	  G.add_edge(diccionario[a],diccionario[c],w=b)

    elif (sep == "nnI"):
      if (c == "pp"):
	c = 1
      else:
	c=float(c)

      if (a in diccionario and b in diccionario) and (diccionario[a] != diccionario[b]):
	if ((G.has_edge(diccionario[a],diccionario[b]) == False) and (G.has_edge(diccionario[b],diccionario[a]) == False)):
	  G.add_edge(diccionario[a],diccionario[b],w=c)




G = G.to_undirected()


if not nx.is_connected(G):
  comp_num = 1
  for g in nx.connected_components(G):
    if len(g) >= int(sys.argv[4]):
      H = G.subgraph(g)
      dictEdges = {}
      OUT = open("Componente"+str(comp_num)+'.net',"w")
      OUT.write("%s %s \n" % ("*Vertices", H.number_of_nodes()))
      k = 1

      for i in H.nodes():
	OUT.write('%s "%s" \n' % (k,diccionarioB[i]))
	dictEdges[i] = k
	k = k+1

      OUT.write("%s %s \n" % ("*Edges", H.number_of_edges()))
      for e in H.edges():
	  ed = H.get_edge_data(*e)
	  OUT.write("%s %s %s \n" % (dictEdges[e[0]],dictEdges[e[1]],ed['w']))

      comp_num = comp_num + 1

SALIDA.write("%s %s \n" % ("*Edges", G.number_of_edges()))
for e in G.edges():
    ed = G.get_edge_data(*e)
    SALIDA.write("%s %s %s \n" % (e[0],e[1],ed['w']))
