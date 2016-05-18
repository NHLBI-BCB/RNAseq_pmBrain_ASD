## SumExpr.R
## Script to sum all expression data from cufflinks and htseq counts,
## as well as remove duplicates from cufflinks data

## To be used after the Orion RNA Seq Pipeline, before CD_RNASeq.R

####### Run this code on the server (recommend using a qsub, the for loop takes awhile)

### Use 6.5_Move.sh to move all individual files to compile folder

rm(list=ls())
options(stringsAsFactors =F)
setwd("/hp_shares/mgandal/projects/CommonMind/data/processed/Cuff")

## First, Cufflinks

algn = vector(mode = "list")
algn$Sample.ID = list.files(".","*.fpkm_tracking")

Refrc=read.table(file=paste("./", algn$Sample.ID[1],sep=""),head=T)
ensembl =  Refrc$gene_id
datExpr = data.frame(Sample1= Refrc[,10])
rownames(datExpr) = make.names(ensembl, unique=TRUE)

nsample=length(algn$Sample.ID)
for (i in c(2:nsample)){
  temp=read.table(file=paste(algn$Sample.ID[i],sep=""),head=T)
  temp_names=temp$gene_id
  rownames(temp)=make.names(temp_names,unique=TRUE)
  k=match(rownames(datExpr),rownames(temp))
  print(paste(algn$Sample.ID[i],length(k[!(is.na(k))]),sep="       "))
  datExpr=cbind(datExpr,temp[k,"FPKM"])
}

colnames(datExpr)=as.character(algn$Sample.ID)
colnames(datExpr)=gsub("_genes.fpkm_tracking","",colnames(datExpr))
write.table(datExpr, "FPKM.txt", sep="\t")

## Next, remove duplicates from Cufflinks data

cuff = datExpr
rm(datExpr)

match = cuff[grep("\\.1$",rownames(cuff)),]
match_names = substr(as.character(rownames(match)),1,15)
samples = colnames(cuff)

cuffsum = data.frame(matrix(NA,nrow=length(match_names),ncol=length(samples)))
rownames(cuffsum)=match_names
colnames(cuffsum)=samples

temp = data.frame()

## Make a dataframe with sums of duplicate rows in cuff

idx = which(rownames(cuff) %in% match_names)

j=1
for (i in idx){
  matchy_match = rownames(cuff)[i]
  temp=cuff[grep(as.character(matchy_match),rownames(cuff)),]
  for (k in 1:length(samples)){
    temp_sum = sum(temp[,k])
    cuffsum[j,k] = temp_sum
  }
  j=j+1
  print(paste("On Row",j))
}

## Now substitute summed duplicate rows into rmdupcuff

rmdupcuff = cuff
sub = which(rownames(rmdupcuff) %in% rownames(cuffsum))
rmdupcuff[sub,] = cuffsum

## Now remove duplicate rows from rmdupcuff

dup=cuff[grep("*[.]",rownames(cuff)),]
length = length(rownames(rmdupcuff))

to_remove = which(rownames(rmdupcuff) %in% rownames(dup))
rmdupcuff = rmdupcuff[-to_remove,]

## rmdupcuff should have 63654 genes/rows left

rmdupcuff[grep("*[.]",rownames(rmdupcuff)),] ## Should be 0
dim(rmdupcuff) ## Should be 63654 47

write.csv(rmdupcuff, file="Cuff.csv")

## Now HTSeq Counts, union exon

rm(list=ls())
setwd("/hp_shares/mgandal/projects/CommonMind/data/processed/HTSCexon")
halgn = vector(mode = "list")
halgn$Sample.ID = list.files(".","*_union_count")

hRefrc=read.table(file=paste("./", halgn$Sample.ID[1],sep=""),head=F)
hensembl =  hRefrc[,1]
hdatExpr = data.frame(Sample1= hRefrc[,2])
rownames(hdatExpr) = hensembl

hnsample=length(halgn$Sample.ID)
for (i in c(2:hnsample)){
  htemp=read.table(file=paste(halgn$Sample.ID[i],sep=""),head=F)
  hk=match(hensembl,htemp[,1])
  print(paste(i,halgn$Sample.ID[i],length(hk[!(is.na(hk))]),sep="       "))
  hdatExpr=cbind(hdatExpr,htemp[hk,2])
}

colnames(hdatExpr)=as.character(halgn$Sample.ID)
colnames(hdatExpr)=gsub("_exon_union_count","",colnames(hdatExpr))
write.csv(hdatExpr, file="HTSCexon.csv")

## Now HTSeq Counts, union gene

rm(list=ls())
setwd("/hp_shares/mgandal/projects/CommonMind/data/processed/HTSCgene")
algn = vector(mode = "list")
algn$Sample.ID = list.files(".","*_union_count")

Refrc=read.table(file=paste("./", algn$Sample.ID[1],sep=""),head=F)
ensembl =  Refrc[,1]
datExpr = data.frame(Sample1= Refrc[,2])
rownames(datExpr) = ensembl

nsample=length(algn$Sample.ID)
for (i in c(2:nsample)){
  temp=read.table(file=paste(algn$Sample.ID[i],sep=""),head=F)
  k=match(ensembl,temp[,1])
  print(paste(i,algn$Sample.ID[i],length(k[!(is.na(k))]),sep="       "))
  datExpr=cbind(datExpr,temp[k,2])
}

colnames(datExpr)=as.character(algn$Sample.ID)
colnames(datExpr)=gsub("_gene_union_count","",colnames(datExpr))
write.csv(datExpr, file="HTSCgene.csv")



