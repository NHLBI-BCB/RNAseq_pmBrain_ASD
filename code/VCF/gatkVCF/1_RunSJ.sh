## Script to submit an Rscript to Orion queue
## Use this qsub: qsub -cwd -V -N RunR.take2 -S /bin/bash -l h_data=16G 1_RunSJ.sh

#!/bin/bash

cd /geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/code/VCF/getVCF   #directory where code is located

Rscript --vanilla 2_SJ.out.ALL.R
