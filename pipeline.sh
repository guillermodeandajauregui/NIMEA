#for this pipeline to work, it is necessary to compile Infomap and place it in this directory.
#and to have a copy of the original ARACNE2.src.tar.gz in this directory

#construct network from expression Matrix

##generate condor job
python parallel_aracne/genera_condor.py \
	--aracne_tgz ARACNE.src.tar.gz \
	--expfile_bz2 exp_matrix.bz2 \
	--probes [path/to/probelist].txt \
	--run_id X \
	--outdir Y \
	--p 1

#submit job to HTCondor
condor_submit run_id.condor

#convert to SIF format

adj2sif.sh X.adj X.sif

#prune network to a given number of edges
RScript filter_net.R X.sif X.filter.sif

#format adaptation
python sif2infomap.py X.filter.sif "tab" "nIn"

#Run infomap on constructed network
#mkdir infomap_results #uncomment for non hierarchical analysis
mkdir infomap_results_hierarchical
for net in $(*.net); do

	#echo $net
#	./Infomap $net /infomap_results --map --silent #uncomment for non hierarchical analysis
	./Infomap $net /infomap_results_hierarchical --silent
done

#run Enrichment analysis on detected modules
cd infomap_results_hierarchical
./Enrichment.sh

#done!
