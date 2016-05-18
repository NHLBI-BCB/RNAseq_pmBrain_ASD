#!/bin/bash

## Script to delete many files at once
## To submit: qsub -cwd -V -N del -S /bin/bash -q geschwind.q Delete.sh

SOURCEDIR=/hp_shares/mgandal/projects/CommonMind/source
INPUTDIR=/hp_shares/mgandal/projects/CommonMind/data/processed

cd $SOURCEDIR

while read direc;do

	cd $INPUTDIR/$direc

	rm *
	ln -s /hp_shares/mgandal/projects/CommonMind/data/bam/${direc}.accepted_hits.sort.coord.bam* ${INPUTDIR}/${direc}
	

done<all.txt

