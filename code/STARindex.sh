#!/bin/bash

## Jillian Haney, 05/20/2015
## Code to create a STAR index
## Code to run script: qsub -cwd -V -S /bin/bash -N STAR_Hs_rRNA -q geschwind.q -l h_data=64G,h_rt=24:00:00 -pe shared 8 STARindex.sh

### Add paths and variables (if needed)


STAR=/geschwindlabshares/CrossDisorder_transcriptome_comparison/1_RNAseq/bin/STAR/bin/Linux_x86_64/STAR
STAR_INDEX=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/refGen/STAR_rRNA_Hs75
FA=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/refGen/Homo_sapiens.GRCh37.75.rRNA.fa
GTF=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/refGen/Homo_sapiens.GRCh37.75.gtf

### Declare Input Variables

INPATH=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/refGen/

cd $INPATH

## STAR Index

$STAR --runMode genomeGenerate --genomeDir $STAR_INDEX --genomeFastaFiles $FA   --runThreadN 8
echo "STAR Indexing complete"
