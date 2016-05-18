#!/bin/bash

### Created by Jillian Haney, 08/12/15
### Script to go through FastQC output files and print the samples that failed "Per base sequence quality" in the output
### See the end of your 'Name.o###' file after the script completes to identify the samples that failed
### You can edit the row (the FastQC parameter you are interested in identifying FAILs in) by changing what 'FNR' is equal to in the 'awk' function
### You can also unzip and zip your fastqc files before and after the script runs if you would like to avoid the 'Name.o###' unzip reporting output 
### To submit: qsub -cwd -V -N flagFastQC -S /bin/bash -q geschwind.q -l h_rt=1:00:00,h_data=8G Flag_FastQC.sh

INPUTDIR=/hp_shares/mgandal/projects/BrainGVEX/FastQC

cd $INPUTDIR

unzip \*.zip

for fastqc in *_fastqc;do

cd $INPUTDIR/$fastqc

awk '{if(FNR==2 && $1=="FAIL") print $1"\t"$6}' summary.txt

done

cd $INPUTDIR

rm -r *_fastqc
