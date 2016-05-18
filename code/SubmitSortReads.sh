## Script to sort reads

SOURCE=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/source
WORKDIR=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/data/starQCtest
CODE=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/code

cd $SOURCE

while read direc;do

qsub -cwd -o $WORKDIR/log2 -e $WORKDIR/log2 -V -S /bin/bash -q geschwind.q -N Sort_${direc} -l h_data=36G,h_rt=24:00:00 ${CODE}/SortReads.sh  $direc

done<testSub.txt
