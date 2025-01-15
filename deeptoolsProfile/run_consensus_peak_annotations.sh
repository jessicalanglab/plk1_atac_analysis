#!/bin/bash

consensus_peaks_path="/project/LangATAC/pipeline-output/merged-230504_VL00320_62_AACNJL5M5-230426_VL00320_57_AACML2FM5/analysis/deeptoolsProfile/input/macs2/consensus_peaks.bed"
gtf_file="/project/LangATAC/reference-genomes/hg38.igenomes.gtf"
annotations_output_file="/project/LangATAC/pipeline-output/merged-230504_VL00320_62_AACNJL5M5-230426_VL00320_57_AACML2FM5/analysis/deeptoolsProfile/input/macs2/consensus_peaks.annotatePeaks.txt"

echo "#############################################"
echo "#######   RUNNING HOMER ANNOTATION  #########"
echo "#############################################"
echo ""

# path to HOMER executable
export PATH="/project/LangATAC/homer/.//bin/:$PATH"

command="$(annotatePeaks.pl ${consensus_peaks_path} hg38 -gtf ${gtf_file} > ${annotations_output_file})"
echo $command
$command

echo "Finished annotating file"