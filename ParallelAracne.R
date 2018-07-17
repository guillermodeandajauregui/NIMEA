#Adapted from work by Cristobal Fresno
library("BiocParallel")
	BPPARAM=MulticoreParam(workers=parallel::detectCores()-1, progress=TRUE)
	aracneDir<-"PATH/TO/ARACNE"
	dataDir<-"PATH/TO/DATA/"
	outputDir<-"PATH/TO/OUTPUT/"
	probesFile<-"[ProbeList.txt]"
	expresionFile<-"[ExpressionMatrix.tsv]"

probes<-as.character(read.csv(paste(dataDir, probesFile, sep=""), header=FALSE)[,1])
currentDir<-getwd()
setwd(aracneDir)
out<-bplapply(probes, function(probe){
  command<-paste("./aracne2 -i", paste(dataDir, expresionFile, sep=""), "-h", probe,
                 "-o", paste(outputDir, probe, ".adj", sep=""),
                 "-p 1 >", paste(outputDir, probe, ".log", sep=""),
                 "2>", paste(outputDir, probe, ".err", sep=""))
  system(command)
}, BPPARAM=BPPARAM)
setwd(currentDir)