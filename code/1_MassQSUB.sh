#!/bin/bash

## Jillian Haney, 05/20/2015
## Code to submit all samples for FASTQC and STAR Alignment for Stage 1 of RNASeq Pipeline (AN)
## to submit this script: qsub -cwd -o code_output_M1 -e code_error_M1 -S /bin/bash -V -N Submit_1 -q geschwind.q -l h_data=4G,h_rt=1:00:00 1_MassQSUB.sh

INPUTDIR=/hp_shares/mgandal/projects/BrainGVEX/data/temp
CODEDIR=/hp_shares/mgandal/projects/BrainGVEX/code_jill
WORKDIR=/hp_shares/mgandal/projects/BrainGVEX/processed

mkdir -p $WORKDIR/log1

cd $INPUTDIR

for fastq in *_1_sequence.txt.gz;do 	## alter 'R3*_R1_001.fastq.gz' accordingly to match your FASTQ files, but make sure that *_R1 is part of your wildcard term

parts=(${fastq//_1_sequence.txt.gz})
aligndir=${WORKDIR}/${parts}
fastq2=${parts}_2_sequence.txt.gz

echo $fastq
echo $fastq2
echo $aligndir

mkdir -p $aligndir

qsub -cwd -o $WORKDIR/log1/ -e $WORKDIR/log1/ -V -S /bin/bash -N AN1_$parts -q geschwind.q -l h_data=64G,h_rt=12:00:00 -pe shared 8 $CODEDIR/2_FQC_StarAlign.sh $aligndir $INPUTDIR/$fastq $INPUTDIR/$fastq2 $parts

done

