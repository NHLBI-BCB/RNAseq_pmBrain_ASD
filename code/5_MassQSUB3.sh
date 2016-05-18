#!/bin/bash

## Jillian Haney, 05/28/2015
## Code to submit all samples for RNASeq Expression Data Extraction using HTSeq Counts and Cufflinks - for Stage 3 of RNASeq Pipeline (QFY)
## To submit this script: qsub -cwd -o code_output_3 -e code_error_3 -S /bin/bash -V -N Submit_3 -q geschwind.q -l h_data=4G,h_rt=3:00:00 5_MassQSUB3.sh

CODEDIR=/hp_shares/mgandal/projects/CommonMind/code_jill
SOURCEDIR=/hp_shares/mgandal/projects/CommonMind/source
WORKDIR=/hp_shares/mgandal/projects/CommonMind/data/processed
groups=all_minusLastThree.txt


cd $SOURCEDIR

mkdir -p $WORKDIR/log3

while read names;do

	processdir=$WORKDIR/$names

		##For 6_Cuff_Expression.sh
		qsub -cwd -o $WORKDIR/log3 -e $WORKDIR/log3 -V -N QFY3_Cuff_${names} -S /bin/bash -q geschwind.q -l h_data=32G,h_rt=48:00:00 -pe shared 8 $CODEDIR/6_Cuff_Expression.sh $processdir

		##For 6_HTSC_Expression.sh
		qsub -cwd -o $WORKDIR/log3 -e $WORKDIR/log3 -V -N QFY3_HTSC_${names} -S /bin/bash -q geschwind.q -l h_data=16G,h_rt=24:00:00  $CODEDIR/6_HTSC_Expression.sh $processdir

done<$groups
