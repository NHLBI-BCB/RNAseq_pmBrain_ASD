#!/bin/bash

## Jillian Haney, 05/20/2015
## Code to submit a group of samples - run in either one lane OR multiple lanes - for Stage 2 of RNASeq Pipeline (QC)
## To submit this script: qsub -cwd -o code_output_M2 -e code_error_M2 -S /bin/bash -V -N Submit_M2 -q geschwind.q -l h_data=4G,h_rt=1:00:00 3_MassQSUB2.sh

CODEDIR=/hp_shares/mgandal/projects/CommonMind/code_jill
SOURCEDIR=/hp_shares/mgandal/projects/CommonMind/source
WORKDIR=/hp_shares/mgandal/projects/CommonMind/data/processed
groups=test.txt

cd $SOURCEDIR

mkdir -p $WORKDIR/log2

while read names;do

	processdir=$WORKDIR/$names

	mkdir -p $processdir

	echo $processdir

	##qsub -cwd -o $WORKDIR/log2 -e $WORKDIR/log2 -V -S /bin/bash -q geschwind.q -N QC2_${names} -l h_data=8G,h_rt=24:00:00 ${CODEDIR}/4_QC.sh $processdir $names $WORKDIR

	qsub -cwd -o $WORKDIR/log2 -e $WORKDIR/log2 -V -S /bin/bash -q geschwind.q -N QC2_${names} -l h_data=4G,h_rt=24:00:00 ${CODEDIR}/QC_supp.sh $processdir $names 
done<$groups
