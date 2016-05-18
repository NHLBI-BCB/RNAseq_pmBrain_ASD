options(stringsAsFactors=FALSE)
setwd("/hp_shares/mgandal/projects/RNAseq_ASD_pancortical/ASDPanBatch1/processed/vcfcons")

load("snpDATdb138_HighQ_batch1_v1_all.Rdata")
snpMat=datSNP
snpMat = t(snpMat)

snpMat[snpMat==c(-1)] <- NA ## We didn't measure sites that were homozygous for the reference allele, so we're comparing heterozygotes and homozygotes for the non-reference allele only - to improve this clustering, we could re-query these sites to assess homozygousity

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
