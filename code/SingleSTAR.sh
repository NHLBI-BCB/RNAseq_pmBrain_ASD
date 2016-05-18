#!/bin/bash

## Jillian Haney, 05/20/2015
## Code to perform FastQC and align+compile a sample with STAR (with 1 thread)
## This script is meant to be used individually

###Add paths and variables (if needed)

export PATH=$PATH:/share/apps/STAR_2.4.0j/bin/Linux_x86_64

## Chose ensembl FASTA and GTF (v75) as those were the reference sequence/annotation files used previously
## STAR_INDEX created from this FASTA and GTF
## GTF and FASTA originated from gandalm@hoffman2.idre.ucla.edu:/~/RefGenome, downloaded 2/13/15

STAR_INDEX=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/refGen/Thread_STAR_Genome

##Declare Variables

FASTQDIR=/hp_shares/mgandal/projects/RNAseq_ASD_pancortical/ASDPanBatch1/tmp
INPATH=/hp_shares/mgandal/projects/RNAseq_ASD_pancortical/ASDPanBatch1/tmp
FF1=$FASTQDIR/2014-2200_141118_SN484_0322_AC5K6UACXX_8_1_sequence.txt.gz
FF2=$FASTQDIR/2014-2200_141118_SN484_0322_AC5K6UACXX_8_2_sequence.txt.gz

##Go to Directory

cd $FASTQDIR

###Step1: FASTQC

##/share/apps/FastQC-v0.11.2/fastqc --noextract --outdir $INPATH/FastQC $FF1
##/share/apps/FastQC-v0.11.2/fastqc --noextract --outdir $INPATH/FastQC $FF2

###Step2: STAR Alignment

cd $INPATH

##2.1: STAR and .SAM to .BAM

STAR --runMode alignReads --genomeDir $STAR_INDEX --readFilesCommand zcat --readFilesIn $FF1 $FF2 --runThreadN 1
samtools view -bS Aligned.out.sam > Aligned.out.bam
rm -f Aligned.out.sam

