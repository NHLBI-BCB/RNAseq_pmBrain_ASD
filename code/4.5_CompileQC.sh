#!/bin/bash

## Jillian Haney, 05/27/2015
## Script to compile QC information output from Stage 2 of the Orion RNASeq Pipeline
## This script should be used after 4_Multi_Star_Process.sh and 4_Single_Star_Process.sh have completed
## Most QC is derived from Neel Parikshak's script, CompileQCOutput.sh
## To submit: qsub -cwd -V -N QC_comp -S /bin/bash -q geschwind.q -l h_data=16G,h_rt=3:00:00 4.5_CompileQC.sh


## Set location for output and variables

qcdir=/hp_shares/mgandal/projects/CommonMind/data/processed/QC
workingdir=/hp_shares/mgandal/projects/CommonMind/data/processed
bamlist=/hp_shares/mgandal/projects/CommonMind/source/all_final.txt

## Start the RNA-seq summary file

echo "SAMPLE PF_BASES PF_ALIGNED_BASES RIBOSOMAL_BASES CODING_BASES UTR_BASES INTRONIC_BASES INTERGENIC_BASES IGNORED_READS CORRECT_STRAND_READS INCORRECT_STRAND_READS PCT_RIBOSOMAL_BASES PCT_CODING_BASES PCT_UTR_BASES PCT_INTRONIC_BASES PCT_INTERGENIC_BASES PCT_MRNA_BASES PCT_USABLE_BASES PCT_CORRECT_STRAND_READS MEDIAN_CV_COVERAGE MEDIAN_5PRIME_BIAS MEDIAN_3PRIME_BIAS MEDIAN_5PRIME_TO_3PRIME_BIAS SAMPLE LIBRARY READ_GROUP" > ${qcdir}/RNAseqQC.txt
echo "SAMPLE GC WINDOWS READ_STARTS MEAN_BASE_QUALITY NORMALIZED_COVERAGE ERROR_BAR_WIDTH" > ${qcdir}/RNAseqGC.txt
echo "SAMPLE WINDOW_SIZE TOTAL_CLUSTERS ALIGNED_READS AT_DROPOUT GC_DROPOUT" > ${qcdir}/GCsummary.txt
echo "SAMPLE CATEGORY TOTAL_READS PF_READS PCT_PF_READS PF_NOISE_READS PF_READS_ALIGNED PCT_PF_READS_ALIGNED PF_ALIGNED_BASES PF_HQ_ALIGNED_READS PF_HQ_ALIGNED_BASES PF_HQ_ALIGNED_Q20_BASES PF_HQ_MEDIAN_MISMATCHES PF_MISMATCH_RATE PF_HQ_ERROR_RATE PF_INDEL_RATE MEAN_READ_LENGTH READS_ALIGNED_IN_PAIRS PCT_READS_ALIGNED_IN_PAIRS BAD_CYCLES STRAND_BALANCE PCT_CHIMERAS PCT_ADAPTER SAMPLE LIBRARY READ_GROUP" > ${qcdir}/RNAseqAlign.txt
echo "SAMPLE LIBRARY UNPAIRED_READS_EXAMINED READ_PAIRS_EXAMINED UNMAPPED_READS UNPAIRED_READ_DUPLICATES READ_PAIR_DUPLICATES READ_PAIR_OPTICAL_DUPLICATES PERCENT_DUPLICATION ESTIMATED_LIBRARY_SIZE" > ${qcdir}/RNAseqDuplication.txt
##echo "SAMPLE CATEGORY TOTAL_READS PF_READS PCT_PF_READS PF_NOISE_READS PF_READS_ALIGNED PCT_PF_READS_ALIGNED PF_ALIGNED_BASES PF_HQ_ALIGNED_READS PF_HQ_ALIGNED_BASES PF_HQ_ALIGNED_Q20_BASES PF_HQ_MEDIAN_MISMATCHES PF_MISMATCH_RATE PF_HQ_ERROR_RATE PF_INDEL_RATE MEAN_READ_LENGTH READS_ALIGNED_IN_PAIRS PCT_READS_ALIGNED_IN_PAIRS BAD_CYCLES STRAND_BALANCE PCT_CHIMERAS PCT_ADAPTER SAMPLE LIBRARY READ_GROUP" > ${qcdir}/RNAseqAlign_postQC.txt

mkdir $qcdir

while read bfile;do

 if [ -f ${workingdir}/${bfile}/gcbias_stats.txt ]
    then
	echo "Getting rnaseq stats"
	var=`sed -n 8p ${workingdir}/${bfile}/rnaseq_stats.txt`
	echo ${bfile} ${var} >> ${qcdir}/RNAseqQC.txt
	var=`sed -n 11,112p ${workingdir}/${bfile}/rnaseq_stats.txt`
	echo ${bfile} ${var} >> ${qcdir}/TranscriptCoverage.txt

	echo "Getting gcbias stats"
	var=`sed -n 8,1088p ${workingdir}/${bfile}/gcbias_stats.txt`
	echo ${bfile} ${var} >> ${qcdir}/RNAseqGC.txt

	echo "Getting gcbias summary"
	var=`sed -n 8p ${workingdir}/${bfile}/gcbias_summary.txt`
	echo ${bfile} ${var} >> ${qcdir}/GCsummary.txt

	echo "Getting alignment summary"
	var=`sed -n 10p ${workingdir}/${bfile}/alignment_stats.txt`
	echo ${bfile} ${var} >> ${qcdir}/RNAseqAlign.txt

	echo "Getting duplication summary"
	var=`sed -n 8p ${workingdir}/${bfile}/duplication_stats.txt`
	echo ${bfile} ${var} >> ${qcdir}/RNAseqDuplication.txt

    else
	echo "No file for" ${bfile}
    fi	

done<$bamlist
