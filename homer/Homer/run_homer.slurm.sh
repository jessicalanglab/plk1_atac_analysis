#!/bin/bash
#SBATCH --j=RunHOMER%j
#SBATCH --ntasks=1
#SBATCH --time=3:00:00
#SBATCH --mem=6gb
#SBATCH --error=/project/CUTandRun/super-enhancers/slurm/logs/RunHOMER%j.err
#SBATCH --output=/project/CUTandRun/super-enhancers/slurm/logs/RunHOMER%j.out
#SBATCH --mail-type=BEGIN,END,FAILED
#SBATCH --mail-user=rrmoreno@wisc.edu

# Expects peaks_file and output_folder_name to be 
# provided as environment variables

# Ensure slurm output folders exist
slurm_output_folder="/project/CUTandRun/super-enhancers/slurm/logs"
if [ ! -d $slurm_output_folder ]; then
    mkdir $slurm_output_folder
fi

# path to HOMER executable
export PATH="/project/LangATAC/homer/.//bin/:$PATH"

command="findMotifsGenome.pl $peaks_file hg38 $output_folder_name -size 200 -mask"

echo "Running HOMER on peaks file $peaks_file"

echo ""
echo "inputs used:"
echo "peaks file: $peaks_file"
echo "output folder name: $output_folder_name"

echo ""
echo "command used:"
echo $command
echo ""

# Runs HOMER with given parameters
$command

echo "Finished running HOMER on sample $peaks_file"