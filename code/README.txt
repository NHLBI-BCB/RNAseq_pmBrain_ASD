## Explanation of Scripts for ASDPancortical Orion RNAseq Pipeline. Email jillhaney@g.ucla.edu for help.

# Main Pipeline

1_MassQSUB.sh			## Mass submit for alignment from your BatchX fastq-files directory
2_FQC_StarAlign.sh		## FastQC + STAR alignment

Run `ls | cut -c 1-9 | uniq > BatchX.txt` in your 'fastq-files' directory and then move BatchX.txt to your 'source' directory for scripts 3_MassQSUB2.sh and 5_MassQSUB3.sh

Flag_FastQC.sh			## Output will contain reads that failed `per base sequence quality` of FastQC (This module will raise a failure if the lower quartile for any base is less than 5 or if the median for any base is less than 20)
2.5_GatherLogFinal.sh		## This script will gather all final logs and novel splice junctions into a new directory before the alignment directories are deleted by script 4_QC.sh
CompileSTARLog.sh		## This script will compile the % alignment for all samples into one .txt 

3_MassQSUB2.sh			## Mass submit for all processing and QC
4_QC.sh				## Processing and QC
	
4_VCF.sh			## Script to make VCF files from processed BAM files (this step is too long to include in the regular QC script)
4.5_CompileQC.sh		## Compile all QC measures into matrix form (sample x measure)

5_MassQSUB3.sh			## Mass submit for expression extraction
6_Cuff_Expression.sh		## Cufflinks
6_HTSC_Expression.sh		## HTseq Counts

6.5_Move.sh			## Copies all cufflinks and htseq output files to new 'summation' directory
SumExprs.R			## Compiles all cufflinks and htseq output files into matrix form (sample X gene)

# Extra Directories

/batch_submit			## Contains alternate scripts for 3_MassQSUB2.sh and 5_MassQSUB3.sh when limited in amount of jobs that can write to the server at one time
/VCF				## Contains scripts for GATK + Neel's high quality SNP calling from RNAseq

# Extra Scripts

1.5_Submit_Fails.sh		## If any of your samples did not align, use this script to re-align (usually add more memory required)
4_QuickQC.sh			## Faster QC script (does the minimum needed to get expression)
6_Expression.sh			## Run Cufflinks and HTseq Counts sequentially instead of in two separate scripts
ASDPan.R			## Rscript for extra R work investigating samples (ie. investigating why RIN is low)
Delete.sh			## Delete many selected files at once
QC_supp.sh			## Run supplemental QC after 4_QC.sh
SingleSTAR.sh			## Run a single STAR alignment
STARindex.sh			## Create a STAR index
SubmitSortReads.sh		## Submit many samples to only sort reads (feeds into SortReads.sh)
SortReads.sh			## Sort reads for one sample
Test.sh				## A 'Test' script for whatever you want to try
TopHat.sh			## Run a TopHat alignment

