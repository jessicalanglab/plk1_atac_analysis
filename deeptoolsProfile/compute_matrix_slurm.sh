#!/bin/bash
#SBATCH --j=COMPUTEMATRIX%j
#SBATCH --ntasks=1
#SBATCH --time=50:00:00
#SBATCH --mem=128gb
#SBATCH --error=/project/LangATAC/slurm/logs/RunDEEPTOOLS%j.err
#SBATCH --output=/project/LangATAC/slurm/logs/RunDEEPTOOLS%j.out
#SBATCH --mail-type=BEGIN,END,FAILED
#SBATCH --mail-user=rrmoreno@wisc.edu

### Expects output_folder, base_name, bigwig_folder, heatmap_path, and 
# either [peaks_file] or [peaks_files_typed, region_types] 
# to be defined in the environment
echo "base_name: ${base_name}"
echo "peaks_file: ${peaks_file}"
echo "peaks_files_typed: ${peaks_files_typed}"
echo "region_types: ${region_types}"

# Ensure slurm output folders exist
slurm_output_folder="/project/LangATAC/slurm/logs"
if [ ! -d $slurm_output_folder ]; then
    mkdir $slurm_output_folder
fi

# Ensure output_folder exists
if [ ! -d $output_folder ]; then
	mkdir $output_folder
fi

# Commands to activate deep tools environment
source /project/LangATAC/DeepToolsEnv/bin/activate
export PATH="/home/r/rrmoreno/Tools/deepTools2.0/bin/:$PATH"

if [ "$base_name" == "consensus_peaks" ]; then
	# Sort the merged peaks according to average DMSO value
	command="computeMatrix reference-point \
		--referencePoint center \
		--missingDataAsZero --skipZeros --smartLabels --upstream 3000 --downstream 3000 \
		--regionsFileName ${peaks_file} \
		--scoreFileName ${bigwig_folder}/DMSO_REP1.mLb.clN.bigWig ${bigwig_folder}/DMSO_REP2.mLb.clN.bigWig \
			${bigwig_folder}/DMSO_REP3.mLb.clN.bigWig ${bigwig_folder}/DMSO_REP4.mLb.clN.bigWig \
			${bigwig_folder}/3MB_REP1.mLb.clN.bigWig ${bigwig_folder}/3MB_REP2.mLb.clN.bigWig \
			${bigwig_folder}/3MB_REP3.mLb.clN.bigWig ${bigwig_folder}/3MB_REP4.mLb.clN.bigWig \
		--samplesLabel DMSO_REP1 DMSO_REP2 DMSO_REP3 DMSO_REP4 3MB_REP1 3MB_REP2 3MB_REP3 3MB_REP4 \
		--outFileName ${output_folder}/DMSO_3MB.computeMatrix.mat.gz \
		--outFileNameMatrix ${output_folder}/DMSO_3MB.computeMatrix.vals.mat.tab \
		--outFileSortedRegions ${output_folder}/DMSO_3MB.sortedRegions.bed"
	
	# Runs DEEPTOOLS computeMatrix with given parameters
	echo "executing ${command} \n"
	$command
else
	# Sort the merged peaks according to average DMSO value
	command="computeMatrix reference-point \
		--referencePoint center \
		--missingDataAsZero --skipZeros --smartLabels --upstream 3000 --downstream 3000 \
		--regionsFileName ${peaks_files_typed} \
		--scoreFileName ${bigwig_folder}/DMSO_REP1.mLb.clN.bigWig ${bigwig_folder}/DMSO_REP2.mLb.clN.bigWig \
			${bigwig_folder}/DMSO_REP3.mLb.clN.bigWig ${bigwig_folder}/DMSO_REP4.mLb.clN.bigWig \
			${bigwig_folder}/3MB_REP1.mLb.clN.bigWig ${bigwig_folder}/3MB_REP2.mLb.clN.bigWig \
			${bigwig_folder}/3MB_REP3.mLb.clN.bigWig ${bigwig_folder}/3MB_REP4.mLb.clN.bigWig \
		--samplesLabel DMSO_REP1 DMSO_REP2 DMSO_REP3 DMSO_REP4 3MB_REP1 3MB_REP2 3MB_REP3 3MB_REP4 \
		--outFileName ${output_folder}/DMSO_3MB.computeMatrix.mat.gz \
		--outFileNameMatrix ${output_folder}/DMSO_3MB.computeMatrix.vals.mat.tab \
		--outFileSortedRegions ${output_folder}/DMSO_3MB.sortedRegions.bed"

	# Runs DEEPTOOLS computeMatrix with given parameters
	echo "executing ${command} \n"
	$command
fi

echo "Finished running DEEPTOOLS computeMatrix (1/2)"

if [ "$base_name" == "consensus_peaks" ]; then
	# Run DEEPTOOLS Plot Heatmap for all samples
	# Sort by DMSO
	yMax=0.075
	command="plotHeatmap --colorMap "Blues" \
			--yMin 0 --yMax ${yMax} \
			--zMin 0 --zMax 0.3 \
			--matrixFile ${output_folder}/DMSO_3MB.computeMatrix.mat.gz \
			--outFileName ${output_folder}/DMSO_3MB.plotHeatmap.pdf \
			--outFileNameMatrix ${output_folder}/DMSO_3MB.plotHeatmap.mat.tab \
			--sortUsingSamples 1 2 3 4 \
			${additional_commands}"
	echo "executing ${command} \n"
	$command
else
	# Run DEEPTOOLS Plot Heatmap for all samples
	# Sort by DMSO
	yMax=0.4
	command="plotHeatmap --colorMap "Blues" \
			--yMin 0 --yMax ${yMax} \
			--zMin 0 --zMax 0.3 \
			--regionsLabel ${region_types} \
			--matrixFile ${output_folder}/DMSO_3MB.computeMatrix.mat.gz \
			--outFileName ${output_folder}/DMSO_3MB.plotHeatmap.pdf \
			--outFileNameMatrix ${output_folder}/DMSO_3MB.plotHeatmap.mat.tab \
			--sortUsingSamples 1 2 3 4 \
			${additional_commands}"
	echo "executing ${command} \n"
	$command

fi

echo "Finished running DEEPTOOLS plotHeatmap (2/2)"

# Copy the heatmap into the top level output folder
cp ${output_folder}/DMSO_3MB.plotHeatmap.pdf $heatmap_path