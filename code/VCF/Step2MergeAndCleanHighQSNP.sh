#!/bin/bash


## take the compressed vcf files from the ./vcfcomp folder, do filtering for high quality calls, merge teh data, and compile into a re-coded file with 0s, 1s, and 2s

export PERL5LIB=/share/apps/vcftools_0.1.12b/perl
vcfcomp=/hp_shares/mgandal/projects/RNAseq_ASD_pancortical/ASDPanBatch1/processed/vcfcomp
vcfcons=/hp_shares/mgandal/projects/RNAseq_ASD_pancortical/ASDPanBatch1/processed/vcfcons
vcflist=$(ls ${vcfcomp}/*.vcf.gz)

mkdir -p $vcfcons

if [ ! -f ${vcfcons}/mergedSNP_batch1.vcf.gz ]; then

    ## This step takes a long time - maybe up to a day with over 300 files
    /share/apps/vcftools_0.1.12b/bin/vcf-merge ${vcflist} | bgzip -c > ${vcfcons}/mergedSNP_batch1.vcf.gz
    echo Merging Complete
    ##vcf-merge ${vcflist} > ${vcfcons}/mergedHighQSNP_N263.vcf.gz
    
## We apply a read filter (minQ), require the event was genotypable in 1% of samples (geno), and that the event is called based on at least 10 reads (minDP)

/share/apps/vcftools_0.1.12b/bin/vcftools --gzvcf ${vcfcons}/mergedSNP_batch1.vcf.gz --minQ 30 --max-missing-count 308 --minDP 10 --out ${vcfcons}/mergedHighQ_cleanedSNP_batch1_v1 --012
/share/apps/vcftools_0.1.12b/bin/vcftools --gzvcf ${vcfcons}/mergedSNP_batch1.vcf.gz --minQ 30 --max-missing-count 308 --minDP 10 --out ${vcfcons}/mergedHighQ_cleanedSNP_batch1_v1 --recode

##vcftools --gzvcf ${vcfcons}/mergedHighQSNP_batch1.vcf.gz --minQ 30 --geno 0.01 --minDP 10 --out ${vcfcons}/mergedHighQ_cleanedSNP_batch1_v1 --recode --012

else
    echo File is already there!
fi

#vcflowq=/home2/neel/COHO/NeelroopParikshak/ProjectNeuropsychiatricIWGCNA/ExpressionData/DataSets/IndividualData/ASDseq/QCdata/samcalls/output/lowq
#vcflist=$(ls -d ${vcflowq}/*.vcf)
#if [ ! -f ${vcfcons}/mergedLowQSNP_N263.vcf.gz ]; then
#    vcf-merge ${vcflist} | bgzip -c > ${vcfcons}/mergedLowQSNP_N263.vcf.gz
#    vcftools --gzvcf ${vcfcons}/mergedHighQSNP_N263.vcf.gz --minQ 30 --geno 0.01 --minDP 3 --out ${vcfcons}/mergedLowQ_cleanedSNP_N263_v1 --recode --012
#else
#    echo File is already there!
#fi
