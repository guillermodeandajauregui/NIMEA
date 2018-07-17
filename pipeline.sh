#for this pipeline to work, it is necessary to compile Infomap and place it in this directory.
#and to have a copy of the original ARACNE2.src.tar.gz in this directory

#construct network from expression Matrix

#or substitute input for infomap with a null modell generated network

#Edit the following script to enter paths to required ARACNE and inputs
Rscript ParallelAracne

#Convert to SIF file
adj2sif.sh *.adj X.sif 10000

#prune network to a given number of edges
RScript filter_net.R X.sif X.filter.sif

#format adaptation
Rscript sif2net.R

#Run infomap on constructed network
#modify file to add paths to parameters
./runInfomap.sh

#break output .tree file into lists of modules

#modify file to add paths to inputs and outputs
RScript breakTree.R

#run Enrichment analysis on detected modules
cd infomap_results_hierarchical
./Enrichment.sh

#done!
