#!/bin/bash

## Script to move/copy many files at once
## To submit: qsub -cwd -V -N move -S /bin/bash -q geschwind.q 6.5_Move.sh

SOURCEDIR=/hp_shares/mgandal/projects/CommonMind/source
INPUTDIR=/hp_shares/mgandal/projects/CommonMind/data/processed

cd $SOURCEDIR

mkdir -p ${INPUTDIR}/Cuff
mkdir -p ${INPUTDIR}/HTSCgene
mkdir -p ${INPUTDIR}/HTSCexon

while read direc;do

cd ${INPUTDIR}/${direc}/Cufflinks

cp genes.fpkm_tracking ${INPUTDIR}/Cuff/${direc}_genes.fpkm_tracking

cd ${INPUTDIR}/${direc}

cp gene_union_count ${INPUTDIR}/HTSCgene/${direc}_gene_union_count
cp exon_union_count ${INPUTDIR}/HTSCexon/${direc}_exon_union_count

done<all_final.txt

