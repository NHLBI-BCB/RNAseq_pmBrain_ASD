#!/bin/bash

## folder containing all vcf files in directories named after the fastq file. So, for example, this_file.fastq has a vcf file called ./vcfdata/this_file/var.flt.vcf
vcfdir=/hp_shares/mgandal/projects/RNAseq_ASD_pancortical/ASDPanBatch1/processed
vcflist=/hp_shares/mgandal/projects/RNAseq_ASD_pancortical/ASDPanBatch1/source/Batch1.txt

## folder to output compressed vcf files
vcfcomp=${vcfdir}/vcfcomp

mkdir -p $vcfcomp

## We can construct two versions of the compiled vcf file, one that is "high quality" and another that is "low quality." We can IGNORE this for now.
##vcfhighq=/home2/neel/COHO/NeelroopParikshak/ProjectNeuropsychiatricIWGCNA/ExpressionData/DataSets/IndividualData/ASDseq/QCdata/samcalls/output/highq
##vcflowq=/home2/neel/COHO/NeelroopParikshak/ProjectNeuropsychiatricIWGCNA/ExpressionData/DataSets/IndividualData/ASDseq/QCdata/samcalls/output/lowq

## First move all files to one folder, and compress for use with vcftools

while read vdir;do

    ## First we compress the vcf files and rename them by the fastq filename
    ##target=$(basename $vdir)
    target=$vdir
    echo Starting ${target}
    if [ ! -f ${vcfcomp}/${target}.vcf.gz.tbi ]; then
	cp ${vcfdir}/${vdir}/var.flt.vcf ${vcfcomp}/${target}.vcf
	bgzip ${vcfcomp}/${target}.vcf
	tabix  ${vcfcomp}/${target}.vcf.gz
    else
	echo File is already there!
    fi

    ##Ignore for now
#    if [ ! -f ${vcflowq}/${target}_lowQ.vcf.gz.tbi ]; then
#	vcftools --gzvcf ${vcfcomp}/${target}.vcf.gz --minQ 30 --remove-indels --minDP 3 --out ${vcflowq}/${target}_lowQ --recode
#	bgzip ${vcflowq}/${target}_lowQ.vcf
#	tabix  ${vcflowq}/${target}_lowQ.vcf.gz
#    else
#	echo LowQ file is already there!
#    fi

    ## Ignore for now
    ## We apply some filters to the vcf file, and output the compressed "high quality" vcf file
#    if [ ! -f ${vcfhighq}/${target}_highQ.vcf.gz.tbi ]; then
#	vcftools --gzvcf ${vcfcomp}/${target}.vcf.gz --minQ 30 --remove-indels --minDP 20 --out ${vcfhighq}/${target}_highQ --recode
#	bgzip ${vcfhighq}/${target}_highQ.vcf
#	tabix  ${vcfhighq}/${target}_highQ.vcf.gz
#    else
#	echo HighQ file is already there!
#    fi

#    rm ${vcfcomp}/${target}_highQ.vcf
#    rm ${vcfcomp}/${target}_highQ.vcf.gz
    
    ##Ignore for now
    ##vcftools --vcf ${vdir}/var.flt.vcf --minQ 5 --remove-indels --minDP 10 --out ${vcfhighq}/${target}_highQ --recode
    ##tabix  ${vcfcomp}/${target}_highQ.vcf.gz
    echo Completed ${target}

done<${vcflist}

### Ignore for now
## Include positions which are present in at least 5 files
#vcflist=$(ls -d ${vcfcomp}/*_highQ.vcf.gz)
#vcfcons=/home2/neel/COHO/NeelroopParikshak/ProjectNeuropsychiatricIWGCNA/ExpressionData/DataSets/IndividualData/ASDseq/QCdata/samcalls/output/vcfcons
#vcf-isec -o -n +5 ${vcflist} | bgzip -c > ${vcfcons}/N263SharedAmongAtLeast5Samples.vcf.gz 
