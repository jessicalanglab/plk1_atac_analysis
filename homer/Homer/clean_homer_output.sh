#!/bin/bash

homer_slurm_path="/project/LangATAC/pipeline-output/merged-230504_VL00320_62_AACNJL5M5-230426_VL00320_57_AACML2FM5/analysis/homer/test_peak_cutoff/run_homer.slurm.sh"
test_peak_cutoff="/project/LangATAC/pipeline-output/merged-230504_VL00320_62_AACNJL5M5-230426_VL00320_57_AACML2FM5/analysis/homer/test_peak_cutoff"
input_peaks_folder="${test_peak_cutoff}/input_peaks"

echo "#############################################"
echo "#######   CLEANING UP HOMER OUTPUT   ########"
echo "#############################################"
echo ""

# Ensure output folders exist
all_output_folder="${test_peak_cutoff}/output_homer/knownResults"
if [ ! -d $all_output_folder ]; then
    mkdir $all_output_folder
fi

# loop over peaks files
for f in ${input_peaks_folder}/*
do
	# Pick apart file name
	extension=${f##*.}
	without_extension=${f%.*}
	base_name=$(basename "$without_extension")
	
	if [ -f $f ]; then
		peaks_file=$f
		output_folder_name="${test_peak_cutoff}/output_homer/${base_name}"
		echo "Moving ${base_name}"
		known_results_file="${output_folder_name}/knownResults.html"
		new_known_results_path="${all_output_folder}/${base_name}.html"
		cp $known_results_file $new_known_results_path
	fi
done

echo ""
echo "Finished moving files"