Pre-reqs:
- Install [DeepTools](https://deeptools.readthedocs.io/en/develop/content/installation.html)

To perform the profile plots, use the following steps:
1. Run `setup_profile_plot_data.ipynb` (a step in this is running `run_consensus_peak_annotations.sh`)
2. `source /project/LangATAC/DeepToolsEnv/bin/activate`
3. Run `run_deeptools_profiling.sh` to make the profile plots
4. Run `launch_analyze_deeptools_results.ipynb` to get the violin plots and stats analyses
5. If necessary, adjust Ymax in the `compute_matrix_slurm.sh` and re-run the plot heatmap portion of `run_deeptools_profiling.sh`