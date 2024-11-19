#!/bin/bash
#SBATCH --j=COMPUTEMATRIX%j
#SBATCH --ntasks=1
#SBATCH --time=50:00:00
#SBATCH --mem=128gb
#SBATCH --error=/project/LangATAC/slurm/logs/RunDEEPTOOLS%j.err
#SBATCH --output=/project/LangATAC/slurm/logs/RunDEEPTOOLS%j.out
#SBATCH --mail-type=BEGIN,END,FAILED
#SBATCH --mail-user=rrmoreno@wisc.edu


# Dispatch with: 
# sbatch --job-name="COMPUTE_MATRIX" \
# "/project/LangATAC/pipeline-output/merged-230504_VL00320_62_AACNJL5M5-230426_VL00320_57_AACML2FM5/analysis/deeptoolsProfile/compute_matrix_slurm.sh"

# Ensure slurm output folders exist
slurm_output_folder="/project/LangATAC/slurm/logs"
if [ ! -d $slurm_output_folder ]; then
    mkdir $slurm_output_folder
fi

# Commands to activate deep tools environment
# source /project/CUTandRun/super-enhancers/DeepToolsEnv/bin/activate
export PATH="/home/r/rrmoreno/Tools/deepTools2.0/bin/:$PATH"

# Input and output folders
input_peaks_folder_clean="/project/LangATAC/pipeline-output/merged-230504_VL00320_62_AACNJL5M5-230426_VL00320_57_AACML2FM5/analysis/deeptoolsProfile/input/macs2"
input_bigwig_folder="/project/LangATAC/pipeline-output/merged-230504_VL00320_62_AACNJL5M5-230426_VL00320_57_AACML2FM5/analysis/deeptoolsProfile/input/bigwig"
output_folder="/project/LangATAC/pipeline-output/merged-230504_VL00320_62_AACNJL5M5-230426_VL00320_57_AACML2FM5/analysis/deeptoolsProfile/output"

# Combine and merge peaks from all 3MB and DMSO replicates
combined_peaks_file="${input_peaks_folder_clean}/combined_peaks.bed"
sorted_peaks_file="${input_peaks_folder_clean}/combined_peaks.sorted.bed"
merged_peaks_file="${input_peaks_folder_clean}/combined_peaks.merged.bed"
cat ${input_peaks_folder_clean}/3MB_REP*.bed ${input_peaks_folder_clean}/DMSO_REP*.bed > $combined_peaks_file
bedtools sort -i $combined_peaks_file > $sorted_peaks_file
bedtools merge -i $sorted_peaks_file > $merged_peaks_file


	
# Sort the merged peaks according to average DMSO value
command="computeMatrix reference-point \
	--referencePoint center \
	--missingDataAsZero --skipZeros --smartLabels --upstream 3000 --downstream 3000 \
	--regionsFileName ${merged_peaks_file} \
	--scoreFileName ${input_bigwig_folder}/DMSO_REP1.mLb.clN.bigWig ${input_bigwig_folder}/DMSO_REP2.mLb.clN.bigWig \
		${input_bigwig_folder}/DMSO_REP3.mLb.clN.bigWig ${input_bigwig_folder}/DMSO_REP4.mLb.clN.bigWig \
		${input_bigwig_folder}/3MB_REP1.mLb.clN.bigWig ${input_bigwig_folder}/3MB_REP2.mLb.clN.bigWig \
		${input_bigwig_folder}/3MB_REP3.mLb.clN.bigWig ${input_bigwig_folder}/3MB_REP4.mLb.clN.bigWig \
	--outFileName ${output_folder}/DMSO_3MB_all.computeMatrix.mat.gz \
	--outFileNameMatrix ${output_folder}/DMSO_3MB_all.computeMatrix.vals.mat.tab \
	--outFileSortedRegions ${output_folder}/DMSO_3MB_all.sortedRegions.bed"


# Runs DEEPTOOLS computeMatrix with given parameters
echo "executing ${command} \n"
$command

echo "Finished running DEEPTOOLS computeMatrix (1/2)"

# Run DEEPTOOLS Plot Heatmap for all samples
# Sort by DMSO
command="plotHeatmap --colorMap "Blues" \
		--yMin 0 --yMax 0.11 \
		--zMin 0 --zMax 0.3 \
		--matrixFile ${output_folder}/DMSO_3MB_all.computeMatrix.mat.gz \
		--outFileName ${output_folder}/DMSO_3MB_all.plotHeatmap.pdf \
		--outFileNameMatrix ${output_folder}/DMSO_3MB_all.plotHeatmap.mat.tab \
		--sortUsingSamples 1 2 3 4"
echo "executing ${command} \n"
$command

echo "Finished running DEEPTOOLS plotHeatmap (2/2)"