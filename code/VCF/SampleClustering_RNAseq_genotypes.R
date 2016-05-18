## Neelroop Parikshak
## Combine genotype data from multiple resources to ensure that it agrees across different experiments
options(stringsAsFactors=FALSE)
setwd("/hp_shares/mgandal/projects/RNAseq_ASD_pancortical/ASDPanBatch1/processed/vcfcons")

allSNP <- vector(mode="list",length=3)
library(Cairo)
library(WGCNA)
library(biomaRt)
library(gplots)
CairoFonts(regular="Arial:style=Regular",bold="Arial:style=Bold",italic="Arial:style=Italic",bolditalic="Arial:style=Bold Italic,BoldItalic",symbol="Symbol")

## db138 SNPs called from RNA-seq - many values are missing
##load("dbSNP138_batch1_HighQ_in5percent.Rdata")
load("snpDATdb138_HighQ_batch1_v1_all.Rdata")
snpMat=datSNP
snpMat = t(snpMat)
#snpMat_GATK=snpMat

load("key.RData")
snpMat = as.data.frame(snpMat)

## Look at Y chromosome with GATK SNPs

datY=datSNP[,grep("Y",colnames(datSNP))]
IDs = read.csv("RNAseqSNPclusters_allID_db138.csv")
idx = match(rownames(datY),IDs$D_ID)
IDs = IDs[idx,]
rownames(datY) = paste(rownames(datY),IDs$Sex,sep="_")
datY[datY==c(-1)] <- NA

fem=grep("_F",rownames(datY))
male=grep("_M",rownames(datY))
table(is.na(datY[fem,]))
table(is.na(datY[male,]))

## > table(is.na(datY[fem,]))

##FALSE  TRUE 
##5206  4109 
##> table(is.na(datY[male,]))
##FALSE  TRUE 
##19765 13040 
##> 4109/5206
##[1] 0.7892816        ~80% NAs in females for Y chromosome SNPs
##> 13040/19765
##[1] 0.6597521        ~65% NAs in males for Y chromosome SNPs

## gather samples from 3 males and 3 femles for investigation

idTest = IDs$D_ID[c(101,102,103,1,2,3,108,109,110,119,120,121,287,288,289,65,66,67)]
idx = match(idTest,IDs$D_ID)
idTest = cbind(as.character(as.factor(idTest)),IDs[idx,3:5])
colnames(idTest)[1] = "D-ID"
idTest$Name = paste(idTest$`D-ID`,idTest$Sex,sep="_")
write.csv(idTest,file="IGV_VCF_testSamples.txt")


#load("/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/data/processed/vcfcons/dbSNP138_batch1_HighQ_in5percent.Rdata")
## GATK cuts 261 from original pipeline 598 highQ snps
#rm(snpMat)
#snpMat=snpMat_GATK

snpMat[snpMat==c(-1)] <- NA ## We didn't measure sites that were homozygous for the reference allele, so we're comparing heterozygotes and homozygotes for the non-reference allele only - to improve this clustering, we could re-query these sites to assess homozygousity

snpCor <- cor(data.matrix(snpMat),method="spearman",use="pairwise.complete.obs")
save(snpCor,file="snpCor.RData")
load("snpCor.RData")
snpDiff <- snpN <- snpP <- matrix(NA,nrow(snpCor),ncol(snpCor))

for (i in 1:nrow(snpCor)) {
  print(i)
  for (j in 1:ncol(snpCor)) {
    if (nrow(na.omit(cbind(snpMat[,i],snpMat[,j])))>10) {
      snpP[i,j] <- cor.test(as.numeric(snpMat[,i]),as.numeric(snpMat[,j]),method="spearman",use="pairwise.complete.obs")$p.value
      snpN[i,j] <- nrow(na.omit(cbind(snpMat[,i],snpMat[,j])))
      snpDiff[i,j] <- sum(abs(na.omit(cbind(snpMat[,i],snpMat[,j]))[,1]-na.omit(cbind(snpMat[,i],snpMat[,j]))[,2])==1)
    } else {
      snpN[i,j] <- snpDiff[i,j] <- snpP[i,j] <- NA
    }     
  }
}

save(snpCor,snpDiff,snpN,snpP,file="snpClusteringData_snp138_all.Rdata")
load("snpClusteringData_snp138_all.Rdata")
table(is.na(snpP)) ## how many could we not call SNP identity with? - 828 for GATK

quantile(snpP,na.rm=TRUE,c(0.01,0.02,0.03,0.04,0.05,0.1,0.2))
bfsnpP <- snpP*(nrow(snpP)^2/2-nrow(snpP))
bfsnpP[bfsnpP>1] <- 1
quantile(bfsnpP,na.rm=TRUE,c(0.01,0.02,0.03,0.04,0.05,0.1,0.2))

quantile(snpDiff[bfsnpP<0.05],na.rm=TRUE,c(0.01,0.02,0.03,0.04,0.05,0.1,0.2))
quantile(snpN[bfsnpP<0.05],na.rm=TRUE,c(0.01,0.02,0.03,0.04,0.05,0.1,0.2))
quantile(snpDiff[bfsnpP<0.05]/snpN[bfsnpP<0.05],na.rm=TRUE,c(0.01,0.02,0.03,0.04,0.05,0.1,0.2))
sum(snpDiff[bfsnpP<0.05]/snpN[bfsnpP<0.05]>0,na.rm=TRUE)

## Extract samples that have high correlations to each other
seqSNPs <- apply(!is.na(snpMat),2,sum)
colnames(snpCor) <- paste(colnames(snpCor),"#SNPs:",apply(!is.na(snpMat),2,sum))
snpCor[is.na(snpCor)] <- 0 ## kind of an unfair penalty for not having a measure here, only 6 - 26 for GATK
snpCorThresh <- snpCor
snpCorThresh[(abs(bfsnpP)>0.05)|(snpCor<0.5)] <- 0  ## only 8222 correlations pass this threshold of 97338
## GATK, 15600 pass of 97344

## snpCorThresh MUCH more strict than snpCor 

######################
bfsnps_wDat = read.csv("bfCorrectedRNAseqSNPclusters_db138_wIDs.csv")
idx = match(rownames(snpCorThresh),bfsnps_wDat$ID)
bfsnps_wDat = bfsnps_wDat[idx,]

snpCorThresh_IDs = snpCorThresh
rownames(snpCorThresh_IDs) = bfsnps_wDat$Subject
######################

######################
snpCor_wDat = read.csv("RNAseqSNPclusters_db138_wIDs.csv")
idx = match(rownames(snpCor),snpCor_wDat$D_ID2)
snpCor_wDat = snpCor_wDat[idx,]

snpCorIDs = read.csv("RNAseqSNPclusters_allID_db138.csv")
snpCorIDs_temp = snpCor
rownames(snpCorIDs_temp) = snpCorIDs$Sample_ID
snpCorIDs = snpCorIDs_temp
######################


CairoPDF("RNAseq_SNPdb138_data.pdf",width=40,height=40)
par(oma=c(5,5,5,5))
heatmap.2(x=as.matrix(snpCor),distfun = function(c) as.dist(1 - c),margins=c(10,10),main="Clustering of samples with RNA-seq\n(1-spearman's rho), pairwise heterozygous/minor-allele homozygous sites only",cexRow=0.8,cexCol=0.8,col=blueWhiteRed(100),trace="none")

resort <- order(colnames(snpCor))
heatmap.2(x=as.matrix(snpCor[resort,resort]),Rowv=FALSE,Colv=FALSE,distfun = function(c) as.dist(1 - c),margins=c(10,10),main="Ordered samples with RNA-seq\n(1-spearman's rho), pairwise heterozygous/minor-allele homozygous sites only",cexRow=0.8,cexCol=0.8,col=blueWhiteRed(100),trace="none")

heatmap.2(x=as.matrix(snpCorThresh),distfun = function(c) as.dist(1 - c),margins=c(10,10),main="Clustering of samples with RNA-seq\n(1-spearman's rho), pairwise heterozygous/minor-allele homozygous sites only, rho > 0.9",cexRow=0.8,cexCol=0.8,col=blueWhiteRed(100),trace="none")

keep <- seqSNPs > 100  ## originally 100
heatmap.2(x=as.matrix(snpCor[keep,keep]),distfun = function(c) as.dist(1 - c),margins=c(10,10),main="Clustering of samples with RNA-seq\n(1-spearman's rho), pairwise heterozygous/minor-allele homozygous sites only, included only if >100 SNPs called",cexRow=0.8,cexCol=0.8,col=blueWhiteRed(100),trace="none")

heatmap.2(x=as.matrix(snpCorThresh[keep,keep]),distfun = function(c) as.dist(1 - c),margins=c(10,10),main="Clustering of samples with RNA-seq\n(1-spearman's rho), pairwise heterozygous/minor-allele homozygous sites only, rho > 0.9, included if >100 SNPs called",cexRow=0.8,cexCol=0.8,col=blueWhiteRed(100)[51:100],trace="none")

heatmap.2(x=as.matrix((snpCor[keep,keep]+1)/2)^2,distfun = function(c) as.dist(1 - c),margins=c(10,10),main="Clustering of samples with RNA-seq\n(1-spearman's rho), pairwise heterozygous/minor-allele homozygous sites only, included only if >100 SNPs called",cexRow=0.8,cexCol=0.8,col=blueWhiteRed(100),trace="none")

dend <- hclust(as.dist(1-as.matrix((snpCor[keep,keep]+1)/2)^2))
modColors <- cutreeStatic(dendro=dend,cutHeight=0.5,minSize=2)

plotDendroAndColors(dendro=dend,colors=modColors,groupLabels=c("Cluster"),cex.dendroLabels=0.6)

write.csv(cbind(dend$labels,modColors),file="RNAseqSNPclusters_all_db138.csv")

dend <- hclust(as.dist(1-as.matrix((snpCorThresh[keep,keep]+1)/2)^2))
modColors <- cutreeStatic(dendro=dend,cutHeight=0.5,minSize=2)

plotDendroAndColors(dendro=dend,colors=modColors,groupLabels=c("Cluster"),cex.dendroLabels=0.4,abHeight=0.5)

#dend <- hclust(as.dist(1-as.matrix((snpCorThresh_IDs[keep,keep]+1)/2)^2))
#modColors <- cutreeStatic(dendro=dend,cutHeight=0.5,minSize=2)

pdf(file="MDS_bonfSNPs.pdf")
mds = cmdscale(as.dist(1-as.matrix((snpCorThresh[keep,keep]+1)/2)^2),eig=TRUE)
par(mar=c(5.1, 4.1, 4.1, 8.1), xpd=TRUE)
plot(mds$points,col=as.numeric(as.factor(snpCor_wDat$Subject_ID)),pch=19,main = "MDS Plot Subjects SNPs Thresh",bty='L')
legend("topright",inset=c(-0.2,0),legend=levels(as.factor(snpCor_wDat$Subject_ID)),pt.cex=0.4,cex=0.4,fill=as.numeric(as.factor((levels(as.factor(snpCor_wDat$Subject_ID))))))
dev.off()

## BREAK - just run once, aside from other pdf

pdf(file="VisInspect_SNPclusters_all.pdf",width=40,height=15)
par(mar=c(12,12,12,12))

dend <- hclust(as.dist(1-as.matrix((snpCorThresh_IDs[keep,keep]+1)/2)^2))
modColors <- cutreeStatic(dendro=dend,cutHeight=0.5,minSize=2)
plotDendroAndColors(dendro=dend,colors=modColors,groupLabels=c("Cluster"),cex.dendroLabels=0.4,abHeight=0.5)

dev.off()

##

write.csv(cbind(dend$labels,modColors),file="bfCorrectedRNAseqSNPclusters_db138.csv")

dev.off()

## List samples with high correlations to other samples, and number of SNPs supporting this correlation
library(WGCNA)

sampCorList <- rep("<100 SNPs",nrow(snpCorThresh))
sampCorList[keep] <- "OK"
names(sampCorList) <- rownames(snpCorThresh)
for (i in (1:length(sampCorList))[keep]) {
  sampCorList[i] <- paste(sampCorList[i],colnames(snpCor)[snpCor[i,keep]>0.8],collapse=", ")
}

write.table(sort(snpVec),"SNPsFromAllPlatforms.txt",sep="\t",row.names=FALSE,col.names=FALSE,quote=FALSE)

## Match SNPs to chromosomes

source("http://bioconductor.org/biocLite.R")
biocLite()
biocLite("biomaRt")

load("dbSNP138_batch1_HighQ_in5percent.Rdata")

snps = rownames(snpMat)

to_keep = grep("rs",snps)
snps = snps[to_keep]

write.csv(snps,file="snps_to_genes.csv")

bfsnps = read.csv(file="bfCorrectedRNAseqSNPclusters_db138_wIDs_wSex.csv")
snps = read.csv(file="RNAseqSNPclusters_db138_wIDs_wSex.csv")
bfsnps = bfsnps[,-1]

idx=match(bfsnps$X,colnames(snpMat))
snpMat = snpMat[,idx]

datMeta = read.csv(file="datMeta_snps.csv")
datMeta = datMeta[,-1]

idx = match(datMeta$refsnp_id,rownames(snpMat))
snpMat = snpMat[idx,]

### Check gender to see if that matches

y = grep("Y",datMeta$chr_name)

ymat = snpMat[y,]
ymat = rbind(ymat,bfsnps$Sex)
ymatF=ymat[,which(ymat[3,]=="F")]
length(which(ymatF[2,]!=-1))  #26
length(which(ymatF[1,]!=-1))  #1
ncol(ymatF) #68

## 27 F showing a Y chromosome SNP (~40%)

### Cluster with subject name, to visually inspect

write.csv(snpMat,file="snpMat.csv")
write.csv(snpCorIDs,file="snpCor.csv")


### For each subject, tally how many dissectedsamples are in the same module
### cols: subject, total dissectedsamples, # in a shared module, # in a module by themselves

IDs = bfsnps_wDat
ids = unique(IDs$Subject)
qc_mat = data.frame(matrix(NA,nrow=length(ids),ncol=4))
colnames(qc_mat)=c("#Samples","#Shared","#Alone","%Shared")
rownames(qc_mat)=ids

for(i in 1:length(ids)){
  qc_mat[i,1]=length(grep(rownames(qc_mat)[i],IDs$Subject))
  mods=IDs[grep(rownames(qc_mat)[i],IDs$Subject),2]
  qc_mat[i,2]=length(which(duplicated(mods)|duplicated(mods, fromLast=TRUE)==TRUE))
  qc_mat[i,3]= qc_mat[i,1]-qc_mat[i,2] 
  qc_mat[i,4]=signif(qc_mat[i,2]/qc_mat[i,1],4)
}

hist(qc_mat[,4])
length(which(qc_mat[,4]==0))
zeros=qc_mat[which(qc_mat[,4]==0),]
singles=which(zeros[,1]==1)  ## 7 subjects only have one sample, remove
singles=zeros[which(zeros[,1]==1),]
zeros=zeros[-which(zeros[,1]==1),]

## make histograms of subjects with 2:10 total samples to see distribution

plot.new()
pdf(file="Histograms_of_SharedMods.pdf")
hist(qc_mat[-which(qc_mat[,1]==1),4])
par(mfrow=c(2,2))
for(i in 2:10){
  idx=which(qc_mat[,1]==i)
  if(length(idx)>1){
  hist(qc_mat[idx,4],main=i)
  }
  else{
    barplot(qc_mat[idx,4],main=i,xlab="One Subject % Shared")
  }
}
dev.off()

quantile(qc_mat[-which(qc_mat[,1]==1),4])
write.csv(zeros,file="zero_shared_mods.csv")
write.csv(qc_mat,file="all_shared_mods.csv")

## with less samples, higher chance of not clustering together (less chances to correlate and find a trend)
## 14 subjects between 2:6 (only one 5 and one 6) who had no samples sharing a module ( seven 2, one 3, four 4)
## 61 total samples (minus singles)
######## ~23% didn't cluster (not including singles)

### So we see that the percentage clustering together is following a normal distribution, which implies this is somewhat random
### at least in regards to who the sample is coming from (this difference is not being picked up during clustering)
### we would want to see heavier clustering percentage on either side of 50% to rely on this data (either bad or good qc)
### SNPs from this RNAseq data are not reliable for qc validation of samples


