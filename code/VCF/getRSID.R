## This script will load in the output from merging the vcf files and compile it into an R file

setwd("/hp_shares/mgandal/projects/RNAseq_ASD_pancortical/ASDPanBatch1/processed/vcfcons")

## datPos is the position ID of SNPs
options(stringsAsFactors=FALSE)
datPos <- read.table("./mergedHighQ_cleanedSNP_batch1_v1.012.pos")
datPos <- cbind(datPos,datPos[,2],rep(0,nrow(datPos)),rep("-",nrow(datPos)))
write.table(datPos,"./mergedHighQ_cleanedSNP_batch1_v1.012.pos_4_annovar",row.names=FALSE,col.names=FALSE,quote=FALSE)
## FEED THE ABOVE FILE INTO THE ANNOVAR SCRIPT
## Run ANNOVAR

#datPos2 <- read.table("/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/data/processed/wave1/VCF_test/vcfcons/mergedHighQ_cleanedSNP_batch1_v1.012.pos")

## datIDs is the sample name
datIDs <- unlist(read.table("./mergedHighQ_cleanedSNP_batch1_v1.012.indv"))
subIDs = vector(length=312)
subIDs[1:312] <- substr(datIDs[1:312],75,83) ## Clipping the file to get subject IDs


## Get SNP output and save as a compressed Rdata file
datSNP <- read.table("./mergedHighQ_cleanedSNP_batch1_v1.012",sep="\t")
#datSNP2 <- read.table("/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/data/processed/wave1/VCF_test/vcfcons/mergedHighQ_cleanedSNP_batch1_v1.012")
save(datSNP,file="./snpDATdb138_HighQ_batch1_v1_all.Rdata")
load("./snpDATdb138_HighQ_batch1_v1_all.Rdata")

## Switch annotatation over to file
rownames(datSNP) <- subIDs
datSNP <- datSNP[,-c(1)]
colnames(datSNP) <- paste("chr",datPos[,1],"pos",datPos[,2],sep="_")
save(datSNP,file="./snpDATdb138_HighQ_batch1_v1_all.Rdata")
##load(file="./snpDATdb138_HighQ_batch1_v1_all.Rdata")

## Load ANNOVAR output  - I don't recall why I did not include the "keep2" criteria
datAnno_multi <- read.csv("./ASDPanBatch1_multianno.hg19_multianno.csv",header=TRUE)
keep1 <- !is.na(datAnno_multi[,"snp138"])
keep2 <- !is.na(datAnno_multi[,"X1000g2014oct_all"])
keep <- keep1|keep2
## not keeping enough this way, and besides it is more important to just have the SNP information

#unqID = paste(datAnno_multi[,1],datAnno_multi[,2],sep="_")
#rownames(snpMat) = unqID

## Filter by known SNPs and output as a .Rdata file for sample clustering
snpMat <- t(datSNP[,keep])
rownames(snpMat) <- datAnno_multi[keep,"snp138"]
save(snpMat,file="./dbSNP138_batch1_HighQ_in5percent.Rdata")

