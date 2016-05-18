setwd("/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/data/vcfQC_processed")  # set to BAM directory
options(stringsAsFactors=FALSE)
##get all "SJ.out.tab files"
files <- list.files(pattern = "SJ.out.tab",recursive = TRUE)
##Make merged list of all novel splice junction 
#loop through all files, merge two files at a time, then unique
file1=paste("./",files[1],sep="")
SJ.combine=read.delim(file1,header=FALSE,sep="\t",quote = "")
for (i in 2:length(files)){
  file2=paste("./",files[i],sep="")
  SJ=read.delim(file2,header=FALSE,sep="\t",quote = "")
  SJ.merge=rbind(SJ.combine,SJ)
  SJ.combine=unique(SJ.merge)
  print(i)
}
attach(SJ.combine)
new <- SJ.combine[order(V1),] 


## set directory for output
setwd("/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/refGen") 
write.table(new,col.names=FALSE,row.names=FALSE,file="SJ.all.out.tab.take2",sep="\t",quote=FALSE)
