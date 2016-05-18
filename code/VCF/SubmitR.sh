## Script to submit an Rscript to Orion queue
## Use this qsub: qsub -cwd -V -N getMats -S /bin/bash -q geschwind.q -l h_data=24G,h_rt=24:00:00 SubmitR.sh

#!/bin/bash

cd /hp_shares/mgandal/projects/RNAseq_ASD_pancortical/ASDPanBatch1/code/VCF

/geschwindlabshares/CrossDisorder_transcriptome_comparison/1_RNAseq/bin/R/R-3.2.1/bin/Rscript --vanilla getSNPmats.R

