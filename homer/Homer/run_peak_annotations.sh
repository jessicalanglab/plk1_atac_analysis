#!/bin/bash

input_peaks_folder="/project/LangATAC/pipeline-output/merged-230504_VL00320_62_AACNJL5M5-230426_VL00320_57_AACML2FM5/analysis/homer/Input"
nondifferential_output_folder="/project/LangATAC/pipeline-output/merged-230504_VL00320_62_AACNJL5M5-230426_VL00320_57_AACML2FM5/analysis/homer/Output/Annotations"
differential_peaks_folder="/project/LangATAC/pipeline-output/merged-230504_VL00320_62_AACNJL5M5-230426_VL00320_57_AACML2FM5/analysis/homer/Output"
differential_output_folder="/project/LangATAC/pipeline-output/merged-230504_VL00320_62_AACNJL5M5-230426_VL00320_57_AACML2FM5/analysis/homer/Output/Annotations"

gtf_file="/project/LangATAC/reference-genomes/hg38.igenomes.gtf"

echo "#############################################"
echo "#######   RUNNING HOMER ANNOTATIONS  ########"
echo "#############################################"
echo ""

# Ensure output folders exist
if [ ! -d $all_output_folder ]; then
    mkdir $all_output_folder
fi

# path to HOMER executable
export PATH="/project/LangATAC/homer/.//bin/:$PATH"

# loop over input peaks files
for cellline in 3MB DMSO
do
    echo "annotating peaks for ${cellline}"
    command="$(annotatePeaks.pl ${input_peaks_folder}/${cellline}.mRp.clN_peaks.bed hg38 -gtf ${gtf_file} > ${nondifferential_output_folder}/${cellline}.annotatePeaks.txt)"
    echo $command
    $command
done

# loop over differential peaks files
for filename in DMSO.mRp.ClN_peaks_top4000 3MB.mRp.ClN_peaks_top4000 differential_peaks_down_in_3MB_top4000 differential_peaks_down_in_3MB differential_peaks_up_in_3MB
do
    command="$(annotatePeaks.pl ${differential_peaks_folder}/${filename}.bed hg38 -gtf ${gtf_file} > ${differential_output_folder}/${filename}.annotatePeaks.txt)"
    echo "annotating peaks for differential peaks up in ${filename}"
    echo $command
    $command
done

# loop over differential peaks files from part 2
for filename in differential_peaks_down_in_3MB_top4000_any_significance differential_peaks_up_in_3MB_top4000_any_significance
do
    command="$(annotatePeaks.pl ${differential_peaks_folder}/${filename}.bed hg38 -gtf ${gtf_file} > ${differential_output_folder}/${filename}.annotatePeaks.txt)"
    echo "annotating peaks for differential peaks up in ${filename}"
    echo $command
    $command
done

echo ""
echo "Finished annotating files"