## Use this qsub: qsub -cwd -V -N SJindex -S /bin/bash -q geschwind.q -l h_data=16G,h_rt=24:00:00 -pe shared 4 3_new_index.sh
#!/bin/bash

STARcall=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/bin/STAR/bin/Linux_x86_64/STAR
genomeDir=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/refGen/VCF_STAR
hg19=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/refGen/genome.fa
SJ=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/refGen/VCF_STAR/SJ.all.out.tab.sjdb  ##this is what is created from 1_RunSJ.sh and 2_SJ.out.ALL.R



## Make new genome file from new splice junction file
cd $genomeDir

##filter out non-canonical junctions
##echo "Begun filtering out non-canonical junctions"

##awk 'BEGIN {OFS="\t"; strChar[0]="."; strChar[1]="+"; strChar[2]="-";} {if($5>0){print $1,$2,$3,strChar[$4]}}' SJ.all.out.tab > SJ.all.out.tab.sjdb

##Create Index
echo "Begun index creation"
$STARcall --runMode genomeGenerate --genomeDir $genomeDir --genomeFastaFiles $hg19 --sjdbFileChrStartEnd $SJ --sjdbOverhang 49 --runThreadN 4 --limitSjdbInsertNsj 2000000
