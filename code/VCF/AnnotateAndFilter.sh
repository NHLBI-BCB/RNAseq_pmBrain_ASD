#!/bin/bash
vcfcons=/hp_shares/mgandal/projects/RNAseq_ASD_pancortical/ASDPanBatch1/processed/vcfcons
varfile=${vcfcons}/mergedHighQ_cleanedSNP_batch1_v1.012.pos
annodir=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/bin/annovar

## ANNOVAR example / data loading
##annotate_variation.pl -geneanno ${annodir}/example/ex1.human ${annodir}/humandb/ ## Example run

##annotate_variation.pl -buildver hg19 -downdb -webfrom annovar snp137 ${annodir}/humandb/ 
##annotate_variation.pl -buildver hg19 -downdb -webfrom annovar 1000g2012apr ${annodir}/humandb/ 

##${annodir}/annotate_variation.pl -buildver hg19 -downdb -webfrom annovar 1000g2014oct humandb/
##${annodir}/annotate_variation.pl -buildver hg19 -downdb -webfrom annovar snp138 humandb/ 


##table_annovar.pl example/ex1_hg19.human humandb/ -buildver hg19 -out myanno -remove -protocol snp137 -operation f -nastring NA

##${annodir}/table_annovar.pl ${vcfcons}/mergedHighQ_cleanedSNP_batch1_v1.012.pos_4_annovar ${annodir}/humandb/ -buildver hg19 -out ASDPanBatch1 -remove -protocol snp138,1000g2014oct_all -operation f,f -nastring NA




##${annodir}/annotate_variation.pl -buildver hg19 -downdb -webfrom annovar refGene ${annodir}/humandb/

##${annodir}/annotate_variation.pl -buildver hg19 -downdb cytoBand ${annodir}/humandb/

##${annodir}/annotate_variation.pl -buildver hg19 -downdb genomicSuperDups ${annodir}/humandb/ 

##${annodir}/annotate_variation.pl -buildver hg19 -downdb -webfrom annovar esp6500siv2_all ${annodir}/humandb/

##${annodir}/annotate_variation.pl -buildver hg19 -downdb -webfrom annovar 1000g2014oct ${annodir}/humandb/

##${annodir}/annotate_variation.pl -buildver hg19 -downdb -webfrom annovar snp138 ${annodir}/humandb/ 

##${annodir}/annotate_variation.pl -buildver hg19 -downdb -webfrom annovar ljb26_all ${annodir}/humandb/

${annodir}/table_annovar.pl ${vcfcons}/mergedHighQ_cleanedSNP_batch1_v1.012.pos_4_annovar ${annodir}/humandb/ -buildver hg19 -out ASDPanBatch1_multianno -remove -protocol refGene,cytoBand,genomicSuperDups,esp6500siv2_all,1000g2014oct_all,1000g2014oct_afr,1000g2014oct_eas,1000g2014oct_eur,snp138,ljb26_all -operation g,r,r,f,f,f,f,f,f,f -nastring NA -csvout
