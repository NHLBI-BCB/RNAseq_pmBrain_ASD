#!/bin/bash

## Jillian Haney, 05/28/2015
## Script to produce Cufflinks RNASeq expression data files from a sample's processed .bam file obtained in Stage 2 of the pipeline
## The expression file produced should be used for quantification analysis in R
## This script should be fed into 5_MassQSUB3.sh

###Add paths and variables (if needed)

export PATH=$PATH:/share/apps/cufflinks-2.2.1

INPUTDIR=$1

###Chose ensembl FASTA and GTF as those were the reference sequence/annotation files used previously
###Located in gandalm RefGenome, downloaded 2/13/15

GTF=/geschwindlabshares/CrossDisorder_transcriptome_comparison/1_RNAseq/refGen/Homo_sapiens.GRCh37.75.chr.gtf
FA=/geschwindlabshares/CrossDisorder_transcriptome_comparison/1_RNAseq/refGen/hg19.ucsc.fa

cd $INPUTDIR

### Quantification using Cufflinks

echo "Script beginning"

if [ ! -r Cufflinks ]; then

	echo "Begun cufflinks extraction"
	cufflinks -o Cufflinks --num-threads 8 --GTF $GTF  --frag-bias-correct $FA --multi-read-correct --library-type=fr-unstranded --verbose --max-bundle-frags 500000  --compatible-hits-norm PEmatched_markdup_sorted.bam 
	echo "cufflinks files now created"
else
	echo "cufflinks files already created"
fi


##Quantification Filtering and Differential Expression Analysis

##use filezilla (or your favorite scp tool) to move desired Cufflinks files and HTSC files to home folder
##continue quantification analysis using your favorite RScript


## cufflinks -o Cufflinks --GTF Homo_sapiens.GRCh37.75.gtf --frag-bias-correct genome.fa --multi-read-correct --library-type=fr-secondstrand --compatible-hits-norm PEmatched_markdup_sorted.bam
