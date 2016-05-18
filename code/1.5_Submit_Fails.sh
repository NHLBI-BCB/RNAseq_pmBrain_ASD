!/bin/bash

## Jillian Haney, 05/27/2015
## Code to submit all samples that did not align the first time for FASTQC and STAR Alignment for Stage 1 of RNASeq Pipeline
## to submit this script: qsub -cwd -o code_output_1.5 -e code_error_1.5 -S /bin/bash -V -N Submit_1 -q geschwind.q -l h_data=4G,h_rt=3:00:00 1.5_Submit_Fails.sh

INPUTDIR=/geschwindlabshares/CrossDisorder_transcriptome_comparison/datasets/Lieber_Collaboration
CODEDIR=/geschwindlabshares/CrossDisorder_transcriptome_comparison/1_RNAseq/code
WORKDIR=/geschwindlabshares/CrossDisorder_transcriptome_comparison/1_RNAseq/data
SOURCEDIR=/geschwindlabshares/CrossDisorder_transcriptome_comparison/1_RNAseq/source
REDO=redo.txt

cd $SOURCEDIR

while read direc;do

fastq=${direc}_R1_001.fastq.gz
fastq2=${direc}_R2_001.fastq.gz
aligndirec=${WORKDIR}/${direc}
qsub -cwd -o $WORKDIR/log/ -e $WORKDIR/log/ -V -S /bin/bash -N AN1.5_$direc -q geschwind.q -l h_data=64G,h_rt=12:00:00 -pe shared 8 $CODEDIR/2_FQC_StarAlign.sh $INPUTDIR $aligndirec $INPUTDIR/$fastq $INPUTDIR/$fastq2

done<$REDO

