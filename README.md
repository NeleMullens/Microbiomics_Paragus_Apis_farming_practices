# Effect of altitude and management practices on the microbiome of the honeybee Apis mellifera (Apidae) and the hoverfly Paragus borbonicus (Syrphidae) in Morogoro, Tanzania: code analysis

The code in this project refers to the analysis used in the scientific paper “Effect of altitude and management practices on the microbiome of the honeybee Apis mellifera (Apidae) and the hoverfly Paragus borbonicus (Syrphidae) in Morogoro, Tanzania: code analysis” by Mullens et al. The code is subdivided in four scripts, each referring to another step in the analysis. The scripts are numbered in the order of execution. All scripts function within an R project, with standard “data”, “outputs”, and “src” files. 

The first script (01_Data_cleaning_PA.R) describes the code used to filter the dataset. Input for this analysis are fastq files created using metabarcoding sequencing of the V3 and V4 regions of 16S rRNA, in order to sequence the microbiome of -in the case of this study- pollinators. The Fastq files should before implementing this script undergo a quality check. The script contains both cleaning of the data (including using DADA2) as normalization steps. 

The second script (02_Alpha_diversity_analysis_PA.R) focusses on calculating the alpha diversity indices, and the statistical analysis using these diversity indices. Input files to calculate the alpha diversity indices are created in the first script. 

The third script (03_ALDEx2_analysis_PA.R) describes the ALDEx2 analysis.

The fourth script (04_Figures_Apis_Paragus.R) describes how each of the figures (with the exception of figure 1, which contains a map and was created using QGIS) and supplementary information figures were created. 

The analysis executed in PRIMER-e, which is described in the manuscript but not in the provided R scripts, can be recreated using the instructions in the manuscript. 

