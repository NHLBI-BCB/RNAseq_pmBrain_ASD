#!/bin/bash

## Jillian Haney, 05/28/2015
## Script to produce Cufflinks and HTSeq Counts RNASeq expression data files from a sample's processed .bam file obtained in Stage 2 of the pipeline
## The two expression files produced should be used for quantification analysis in R
## This script should be fed into 5_MassQSUB3.sh

###Add paths and variables (if needed)

export PATH=$PATH:/share/apps/cufflinks-2.2.1

INPUTDIR=$1

###Chose ensembl FASTA and GTF as those were the reference sequence/annotation files used previously
###Located in gandalm RefGenome, downloaded 2/13/15

GTF=/geschwindlabshares/CrossDisorder_transcriptome_comparison/1_RNAseq/refGen/Homo_sapiens.GRCh37.75.gtf
FA=/geschwindlabshares/CrossDisorder_transcriptome_comparison/1_RNAseq/refGen/genome.fa

cd $INPUTDIR

### Quantification using Cufflinks and HTseq-Counts

echo "Script beginning"

if [ ! -f PEmatched_markdup_sorted.sam ]; then
	
	echo "Begun .SAM creation"
	samtools view -h -o PEmatched_markdup_sorted.sam PEmatched_markdup_sorted.bam
	awk '{gsub("jM:B:c,-1", "");print}' PEmatched_markdup_sorted.sam > PEmatched_markdup_sorted.sam
	awk '{gsub("jI:B:i,-1", "");print}' PEmatched_markdup_sorted.sam > PEmatched_markdup_sorted.sam
	echo ".SAM file created"
else
	echo ".SAM file already exists"
fi

if [ ! -r Cufflinks ]; then

	echo "Begun cufflinks extraction"
	cufflinks -o Cufflinks --num-threads 8 --GTF $GTF  --frag-bias-correct $FA --multi-read-correct  --compatible-hits-norm PEmatched_markdup_sorted.bam
	echo "cufflinks files now created"
else
	echo "cufflinks files already created"
fi

if [ ! -f exon_union_count ] && [ ! -f gene_union_count ]; then

	echo "Begun gene htsc"
	/share/apps/anaconda/bin/htseq-count --stranded=no --mode=union --type=gene PEmatched_markdup_sorted.sam $GTF >> gene_union_count
	echo "Begun exon htsc"
	/share/apps/anaconda/bin/htseq-count --stranded=no --mode=union --type=exon PEmatched_markdup_sorted.sam $GTF >> exon_union_count
	echo "HTseq Counts file now created"
	rm -f PEmatched_markdup_sorted.sam
else
	echo "HTseq Counts file already created"
fi

### Quantification Filtering and Differential Expression Analysis

##use filezilla (or your favorite scp tool) to move desired Cufflinks files and HTSC files to home folder
##continue quantification analysis using your favorite RScript


