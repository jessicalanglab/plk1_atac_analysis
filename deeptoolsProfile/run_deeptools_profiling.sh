#!/bin/bash

compute_matrix_slurm_path="/project/LangATAC/pipeline-output/merged-230504_VL00320_62_AACNJL5M5-230426_VL00320_57_AACML2FM5/analysis/deeptoolsProfile/compute_matrix_slurm.sh"
compute_matrix_input_bigwig_folder="/project/LangATAC/pipeline-output/merged-230504_VL00320_62_AACNJL5M5-230426_VL00320_57_AACML2FM5/analysis/deeptoolsProfile/input/bigwig"
compute_matrix_input_macs2_folder="/project/LangATAC/pipeline-output/merged-230504_VL00320_62_AACNJL5M5-230426_VL00320_57_AACML2FM5/analysis/deeptoolsProfile/input/macs2"
compute_matrix_output_folder_toplevel="/project/LangATAC/pipeline-output/merged-230504_VL00320_62_AACNJL5M5-230426_VL00320_57_AACML2FM5/analysis/deeptoolsProfile/output"

echo "#########################################################"
echo "####   SUBMITTING DEEPTOOLS PROFILE JOBS TO SLURM   #####"
echo "#########################################################"
echo ""

#######
# Launch consensus peaks
#######
base_name="consensus_peaks"
peaks_file="/project/LangATAC/pipeline-output/merged-230504_VL00320_62_AACNJL5M5-230426_VL00320_57_AACML2FM5/analysis/deeptoolsProfile/input/macs2/consensus_peaks.bed"
	
compute_matrix_output_folder="${compute_matrix_output_folder_toplevel}/${base_name}"
compute_matrix_heatmap_path="${compute_matrix_output_folder_toplevel}/${base_name}.heatmap.pdf"

# execute compute matrix slurm script
slurm_job_name="PROFILE_${peaks_file}_%j"
echo "Submitting slurm job for DEEPTOOLS PROFILE with peaks file ${peaks_file}"
# export provides environment variables to slurm script
sbatch --job-name=$slurm_job_name --export ALL,peaks_file=$peaks_file,bigwig_folder=$compute_matrix_input_bigwig_folder,output_folder=$compute_matrix_output_folder,heatmap_path=$compute_matrix_heatmap_path,base_name=$base_name $compute_matrix_slurm_path		
echo "Done submitting"

#######
# Launch consensus peaks, typed by homer annotations
#######

peaks_files_typed="${compute_matrix_input_macs2_folder}/consensus_exon.bed \
	${compute_matrix_input_macs2_folder}/consensus_intergenic.bed \
	${compute_matrix_input_macs2_folder}/consensus_intron.bed \
	${compute_matrix_input_macs2_folder}/consensus_promoter-tss.bed \
	${compute_matrix_input_macs2_folder}/consensus_tts.bed"

region_types="exon intergenic intron promoter-tss tts"

base_name="consensus_peaks_typed_by_homer_annotations"
compute_matrix_output_folder="${compute_matrix_output_folder_toplevel}/${base_name}"
compute_matrix_heatmap_path="${compute_matrix_output_folder_toplevel}/${base_name}.heatmap.pdf"

# execute compute matrix slurm script
slurm_job_name="PROFILE_${base_name}_%j"
echo "Submitting slurm job for DEEPTOOLS PROFILE ${base_name} ${compute_matrix_slurm_path}"
# export provides environment variables to slurm script
sbatch --job-name=$slurm_job_name --export "ALL,peaks_files_typed=$peaks_files_typed,region_types=$region_types,bigwig_folder=$compute_matrix_input_bigwig_folder,output_folder=$compute_matrix_output_folder,heatmap_path=$compute_matrix_heatmap_path,base_name=$base_name" $compute_matrix_slurm_path
echo "Done submitting"

echo ""
echo "Finished submitting jobs to slurm"