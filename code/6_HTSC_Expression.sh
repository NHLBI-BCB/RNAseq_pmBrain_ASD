#!/bin/bash

## Jillian Haney, 05/28/2015
## Script to produce HTSeq Counts RNASeq expression data files from a sample's processed .bam file obtained in Stage 2 of the pipeline
## The two expression files (gene and exon) produced should be used for quantification analysis in R
## This script should be fed into 5_MassQSUB3.sh

## Way 1 - Picard name sort BAM, samtools convert to SAM, htseq order name, stranded=yes - FAIL
## Way 2 - samtools sort coord BAM to name SAM, htseq order name, stranded=reverse - BEST, way to go
## Way 3 - samtools sort coord BAM to name SAM, htseq order name, stranded=no - same as Way 2

###Add paths and variables (if needed)

INPUTDIR=$1

###Chose ensembl FASTA and GTF as those were the reference sequence/annotation files used previously
###Located in gandalm RefGenome, downloaded 2/13/15

GTF=/geschwindlabshares/CrossDisorder_transcriptome_comparison/1_RNAseq/refGen/Homo_sapiens.GRCh37.75.chr.gtf
FA=/geschwindlabshares/CrossDisorder_transcriptome_comparison/1_RNAseq/refGen/hg19.ucsc.fa
JAV=/usr/java/jdk1.7.0_51/bin
PIC=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/bin/picard-master/dist/picard.jar

cd $INPUTDIR

### Quantification using Cufflinks and HTseq-Counts

echo "Script beginning"

if [ ! -f PEmatched_markdup_namesorted.sam ]; then
	
	##echo "Begun coordinate ordered .SAM creation"
	##samtools view -h -o PEmatched_markdup_sorted.sam PEmatched_markdup_sorted.bam
	##echo "coordinate ordered .SAM file created"
	
	##${JAV}/java -Xmx4g -Djava.io.tmpdir=${INPUTDIR}/tmp -jar ${PIC} SortSam INPUT=PEmatched_markdup_sorted.bam OUTPUT=PEmatched_markdup_namesorted.bam SORT_ORDER=queryname TMP_DIR=${INPUTDIR}/tmp
        ## Reorder the .bam file according to the reference at hand
        ##echo "name sorted_reads.bam is now created"

	echo "Begun name ordered .SAM creation"
	samtools sort -n -O 'sam' -o PEmatched_markdup_namesorted.sam -T temp PEmatched_markdup_sorted.bam
	echo "name ordered .SAM complete"

else
	echo ".SAM file already exists"
fi


if [ ! -f exon_union_count ] || [ ! -f gene_union_count ]; then

	## original way was to not specify an order - this seems to have caused some unpaired mates to be 'double counted', which isn't a big deal but not technically correct

	echo "Begun name gene htsc"
        /share/apps/anaconda/bin/htseq-count  --stranded=no --mode=union --order=name --type=gene PEmatched_markdup_namesorted.sam $GTF >> gene_union_count
        echo "Begun name exon htsc"
        /share/apps/anaconda/bin/htseq-count  --stranded=no --mode=union --order=name --type=exon PEmatched_markdup_namesorted.sam $GTF >> exon_union_count
        echo "HTseq Counts name files now created"
        rm -f PEmatched_markdup_namesorted.sam
	
else
	echo "HTseq Counts file already created"
fi

### Quantification Filtering and Differential Expression Analysis

##use filezilla (or your favorite scp tool) to move desired Cufflinks files and HTSC files to home folder
##continue quantification analysis using your favorite RScript
