## Instructions for how to run this pipeline

(1)	Step1CompileSNP.sh
	## Compiles all vcf files into one folder
(2)	Step2MergeAndCleanHighQSNP.sh
	## Merges all vcf files into one massive vcf file
(3)	getRSID.R
	## Until 'RunANNOVAR' step, to prepare for Annovar
(4)	AnnotateAndFilter.sh
	## Annotates and filters samples based on snps identified
(5) 	getRSID.R
	## Make matrix of snp locations that is numerically coded
	## You can either use the annotations from Annovar to get a smaller group of SNPs
	## OR you can just ignore step (4) and use all high quality snps from (2)
(6) 	SampleClustering_RNAseq_genotypes.R
	## Cluster snp matrix to look for sequencing mistakes
