# Atac-seq and Homer Analysis for Burkard lab

## Introduction  

Goal: Identify known transcription factors with differential expression in 3MB and DMSO cell lines.

Atac-seq was run for 4 biological replicates and 2 technical replicates across the 3MB and DMSO cell lines. 

Sample preparation and Atac-seq was performed by Kristin in the Lang lab.
Analysis is performed by Ryan in the Lang lab.

Biological Questions:

* What motifs are available for binding in the 3MB cell line? What transcription factors are associated with these motifs?
* What motifs are available for binding in the DMSO cell line? What transcription factors are associated with these motifs?
* What motifs are differentially available between the 3MB and DMSO cell lines? What transcription facotrs are associated with these motifs?
 
## Description of files

** The bulk of the valuable information is in `homer/homer-analysis.nb.html` and `homer/Output/Homer-output` **

* `homer/homer-analysis.Rmd` and `homer/homer-analysis.nb.html` - R notebook containing the data processing and descriptions of each step, including instructions to run Homer. Also includes a plot of the annotated peaks using Homer.
* `homer/Homer/` scripts to run Homer analysis on SLURM
* `homer/Output/` peak files generated during data processing
* `homer/Output/Homer-output` results from Homer analysis showing which transcription factor motifs were found

* `homer/determining-cutoffs.Rmd` and `homer/determining-cutoffs.nb.html` - R notebook containing data processing from trying varying cutoffs for the number of peaks to include in the Homer analysis
* `homer/Determining-cutoffs-output/` peak files from trying varying cutoffs
* `homer/Determining-cutoffs-output/Homer-output` results from Homer analysis run on a variety of cutoffs

* `geo_upload` contains a script used to create the metadata for the GEO upload
