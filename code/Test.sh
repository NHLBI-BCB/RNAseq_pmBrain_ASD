#!/bin/bash

## Jillian Haney, 05/20/2015
## Code to submit a group of samples - run in either one lane OR multiple lanes - for Stage 2 of RNASeq Pipeline (QC)
## To submit this script: qsub -cwd -o code_output_M2 -e code_error_M2 -S /bin/bash -V -N Submit_M2 -q geschwind.q -l h_data=4G,h_rt=1:00:00 Test.sh

## IMPORTANT: Due to file writing limitations on orion, you can only submit 10-20 jobs at a time (depending on your .BAM file size)
## Follow the steps below:
## (1) Seperate your samples into batches of the maximum jobs you can run at a time without slowing down the server.
##	You should perform a 'stress test' to see what your maximum is. 10 is usually a safe bet.
## (2) Create batch##.txt files with the names of each of your samples for each batch, and place each batch##.txt in your source directory
##      ie. batch01.txt contains Sample1 Sample2 Sample3 etc.
##      NOTE that your sample name should be at the beginning of your alignment directories (so whatever your .FASTQ files started with, ie. 01-010115_ATGC..R1.fastq.gz, Sample1 = 01-010115)
##      YOU MUST follow syntax of batch01.txt batch02.txt ... batch23.txt ... batch99.txt. If you have more than 99 batches, you will have to run your 'groups' in batches of 99.
## (3) Create an additional .txt file with the names or your batch.txt files, and place this in source
##      ie. groups.txt contains batch01.txt batch02.txt batch03.txt etc.

CODEDIR=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/code
SOURCEDIR=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/source
WORKDIR=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/data/processed/test
GROUP=group.txt
JOBNAME=jrh

cd $SOURCEDIR

mkdir -p $WORKDIR/log2

while read groups;do

	num=$( echo "$groups" | cut -c 6-7 )
	echo $num
	
	cd $SOURCEDIR

	if [ "$groups" = "batch01.txt" ]; then

		while read names;do

		processdir=$WORKDIR/$names

		mkdir -p $processdir

		echo $processdir

		qsub -cwd -o $WORKDIR/log2 -e $WORKDIR/log2 -V -S /bin/bash -q geschwind.q -N QC2_${names}_${JOBNAME}_${num} -l h_data=4G,h_rt=1:00:00 ${CODEDIR}/Test2.sh $processdir $names $WORKDIR

		done<$groups

	else

		while read names;do

                processdir=$WORKDIR/$names

                mkdir -p $processdir

                echo $processdir

                hold_id=$(($num -1))

                qsub -hold_jid *${JOBNAME}*${hold_id}  -cwd -o $WORKDIR/log2 -e $WORKDIR/log2 -V -S /bin/bash -q geschwind.q -N QC2_${names}_${JOBNAME}_${num} -l h_data=4G,h_rt=1:00:00 ${CODEDIR}/Test2.sh $processdir $names $WOR$

                done<$groups

	fi

done<$GROUP
