#!/bin/bash

homer_slurm_path="/project/LangATAC/pipeline-output/merged-230504_VL00320_62_AACNJL5M5-230426_VL00320_57_AACML2FM5/analysis/homer/test_peak_cutoff/run_homer.slurm.sh"
input_peaks_folder="/project/LangATAC/pipeline-output/merged-230504_VL00320_62_AACNJL5M5-230426_VL00320_57_AACML2FM5/analysis/homer/test_peak_cutoff/input_peaks"

echo "#############################################"
echo "####   SUBMITTING HOMER JOBS TO SLURM   #####"
echo "#############################################"
echo ""

# loop over peaks files
for f in ${input_peaks_folder}/*
do
	# Pick apart file name
	extension=${f##*.}
	without_extension=${f%.*}
	base_name=$(basename "$without_extension")
	
	if [ -f $f ]; then
		peaks_file=$f
		output_folder_name="/project/LangATAC/pipeline-output/merged-230504_VL00320_62_AACNJL5M5-230426_VL00320_57_AACML2FM5/analysis/homer/test_peak_cutoff/output_homer/$base_name"

		# execute HOMER
		echo "Submitting slurm job for HOMER with peaks file name ${base_name}"
		slurm_job_name="HOMER_${peaks_file}_%j"
		# export provides environment variables to slurm script
		sbatch --job-name=$slurm_job_name --export ALL,peaks_file=$peaks_file,output_folder_name=$output_folder_name $homer_slurm_path			

	fi
done

echo ""
echo "Finished submitting jobs to slurm"