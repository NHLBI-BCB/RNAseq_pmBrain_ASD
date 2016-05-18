#!/bin/bash

## Jillian Haney, 05/20/2015
## Code to perform FastQC and align a sample with STAR
## This script is meant to be fed into 1_MassQSUB.sh

### Add paths and variables (if needed)

## Chose ensembl FASTA and GTF (v75) as those were the reference sequence/annotation files used previously
## STAR_INDEX created from this FASTA and GTF
## GTF and FASTA originated from gandalm@hoffman2.idre.ucla.edu:/~/RefGenome, downloaded 2/13/15

STAR=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/bin/STAR/bin/Linux_x86_64/STAR
STAR_INDEX=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/refGen/Thread_STAR_Genome
FASTQ_DIR=/hp_shares/mgandal/projects/CommonMind/FastQC

### Declare Input Variables

INPATH=$1
FF1=$2
FF2=$3
NAME=$4

### FASTQC

echo "Script is beginning..."
echo  ${FASTQ_DIR}/${NAME}

if [ ! -f ${FASTQ_DIR}/${NAME}_fastqc.zip ]; then

	/share/apps/FastQC-v0.11.2/fastqc --noextract --outdir $FASTQ_DIR $FF1
	/share/apps/FastQC-v0.11.2/fastqc --noextract --outdir $FASTQ_DIR $FF2
	echo "FastQC complete"
else
	echo "FastQC already performed for this sample lane"
fi

### STAR Alignment

cd $INPATH

## STAR and .SAM to .BAM

if [ ! -f Aligned.out.bam ]; then

	$STAR --runMode alignReads --genomeDir $STAR_INDEX --readFilesCommand zcat --readFilesIn $FF1 $FF2 --runThreadN 8 --outSAMstrandField intronMotif --outFilterIntronMotifs RemoveNoncanonical --outSAMtype BAM Unsorted --outFilterScoreMinOverLread 0.5 --outFilterMatchNminOverLread 0.5 --alignMatesGapMax 200 --outSAMprimaryFlag AllBestScore --outFilterMultimapNmax 10 --outFilterMismatchNmax 3 
	### outFilter parameters require mapped read length to be at least 1/2 the total read length, default 0.66
	echo "STAR alignment complete"
	##samtools view -bS Aligned.out.sam > Aligned.out.bam
	##echo ".SAM now converted to .BAM"
	##rm -f Aligned.out.sam
else	
	echo "STAR alignment already complete for this sample lane"
fi
