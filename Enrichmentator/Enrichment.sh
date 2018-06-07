#!/bin/bash

mkdir RESULTADOS
mv *.pdf RESULTADOS

for i in $(ls *.map)
  do
      d=$(echo $i | cut -d "." -f1 )
      mkdir $d
      mv $i $d
      python lib/Analisis_Infomap2.py $d/$i $d/
      
      for j in $(ls $d/*.txt) 
      do
	  echo $j
	  Rscript lib/Enrichmentator.R  $j
      done

      python lib/EnrichmentMatrix.py $d
      
      Rscript lib/heatmap3.r $d'_GS_GO_BP.csv'
      Rscript lib/heatmap3.r $d'_GS_GO_CC.csv'
      Rscript lib/heatmap3.r $d'_GS_GO_MF.csv'
      Rscript lib/heatmap3.r $d'_kegg.csv'
      
      mv *.csv $d
      mkdir RESULTADOS/$d
      mv *.pdf RESULTADOS/$d
      
  done