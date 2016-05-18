#!/bin/bash

## Script to save all Log.final.out from STAR alignment

## To submit: qsub -cwd -V -N gather -S /bin/bash -q geschwind.q 2.5_GatherLogFinal.sh

INPUTDIR=/hp_shares/mgandal/projects/BrainGVEX/processed

cd $INPUTDIR

mkdir -p $INPUTDIR/logSTAR

for fastq in 20*;do

cd ${INPUTDIR}/${fastq}

cp Log.final.out ${INPUTDIR}/logSTAR/${fastq}_Log.final.out
cp SJ.out.tab ${INPUTDIR}/logSTAR/${fastq}_SJ.out.tab

done

