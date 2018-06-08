# NIMEA
Network Inference and Module Enrichment Analysis, from cancer expression datasets 

1) Infer network from gene expression data using parallel-ARACNe, derived from https://doi.org/10.1186/1471-2105-7-S1-S7 
2) Filter network by MI threshold, preserving the complex network regime of Edges >> Nodes
3) Evaluation of the threshold significance by bootstrap analysis
4) Identify modules in network using Infomap ( https://github.com/mapequation/infomap )
5) Enrichment analysis of gene modules using HTSAnalyzeR ( https://doi.org/doi:10.18129/B9.bioc.HTSanalyzeR )
6) Evaluating of significance through the analysis of null model networks

This pipeline incorporates elements of the work of Sergio Antonio Alcala Corona on module detection, Hugo Tovar and Rodrigo García-Herrera on network inference. 
