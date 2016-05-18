#!/bin/bash

## Jillian Haney, 05/28/2015
## Code to submit all samples for RNASeq Expression Data Extraction using HTSeq Counts and Cufflinks - for Stage 3 of RNASeq Pipeline (QFY)
## To submit this script: qsub -cwd -o code_output_3 -e code_error_3 -S /bin/bash -V -N Submit_3 -q geschwind.q -l h_data=4G,h_rt=3:00:00 5_MassQSUB3.sh

## IMPORTANT: Due to file writing limitations on orion, you can only submit 10-20 jobs at a time (depending on your .BAM file size)
## Follow the steps below:
## (1) Seperate your samples into batches of the maximum jobs you can run at a time without slowing down the server.
##      You should perform a 'stress test' to see what your maximum is. 10 is usually a safe bet.
## (2) Create batch##.txt files with the names of each of your samples for each batch, and place each batch##.txt in your source directory
##      ie. batch01.txt contains Sample1 Sample2 Sample3 etc.
##      NOTE that your sample name should be at the beginning of your alignment directories (so whatever your .FASTQ files started with, ie. 01-010115_ATGC..R1.fastq.gz, Sample1 = 01-010115)
##      YOU MUST follow syntax of batch01.txt batch02.txt ... batch23.txt ... batch99.txt. If you have more than 99 batches, you will have to run your 'groups' in batches of 99.
## (3) Create an additional .txt file with the names of your batch.txt files, and place this in source
##      ie. groups.txt contains batch01.txt batch02.txt batch03.txt etc.

CODEDIR=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/code
SOURCEDIR=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/source/wave2
WORKDIR=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/data/processed/wave2
GROUP=group.txt
JOBNAME=jrh_cuff 					## unique identifier for your jobs

cd $SOURCEDIR

mkdir -p $WORKDIR/log3

while read groups;do

	num=$( echo "$groups" | cut -c 6-7 )
	echo $num

	cd $SOURCEDIR

	if [ "$groups" = "batch01.txt" ]; then

		while read names;do

		processdir=$WORKDIR/$names

		##For 6_Cuff_Expression.sh
		qsub -cwd -o $WORKDIR/log3 -e $WORKDIR/log3 -V -N QFY3_Cuff_${names} -S /bin/bash -q geschwind.q -l h_data=48G,h_rt=48:00:00 -pe shared 8 $CODEDIR/6_Cuff_Expression.sh $processdir

		##For 6_HTSC_Expression.sh
		##qsub -cwd -o $WORKDIR/log3 -e $WORKDIR/log3 -V -N QFY3_HTSC_${names}_${JOBNAME}_${num} -S /bin/bash -q geschwind.q -l h_data=36G,h_rt=24:00:00  $CODEDIR/6_HTSC_Expression.sh $processdir

		done<$groups

	else

		while read names;do

                processdir=$WORKDIR/$names

                mkdir -p $processdir

                echo $processdir

		hold_id=$((10#$num -1))
		
                ##For 6_Cuff_Expression.sh
		qsub -cwd -o $WORKDIR/log3 -e $WORKDIR/log3 -V -N QFY3_Cuff_${names} -S /bin/bash -q geschwind.q -l h_data=48G,h_rt=24:00:00 -pe shared 8 $CODEDIR/6_Cuff_Expression.sh $processdir

		##For 6_HTSC_Expression.sh
		##qsub -hold_jid *${JOBNAME}*${hold_id} -cwd -o $WORKDIR/log3 -e $WORKDIR/log3 -V -N QFY3_HTSC_${names}_${JOBNAME}_${num} -S /bin/bash -q geschwind.q -l h_data=36G,h_rt=24:00:00  $CODEDIR/6_HTSC_Expression.sh $processdir

                done<$groups

	fi


done<$GROUP
