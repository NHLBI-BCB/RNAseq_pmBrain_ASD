## Linear Model of ASDPan 
## Why is RIN low?

options(stringsAsFactors = FALSE)
setwd("C:/Users/Jill/Dropbox/DHGLab/ASDBrain")
dat = read.csv("Processed RNAExtractions_092015_ASDBrain121115.csv",row.names=1)
dat = dat[,-6]

dat = as.data.frame(dat)

pdf(file="Proc RNAExtraction_092015_ANOVA.pdf")

par(mfrow=c(2,2))
par(mar=c(3,2,3,2))

for(i in c(2:5,11)){
  
  if( i == 2 || i == 4 || i == 5 || i == 7 ){
    print(paste(i,"Character Graph",sep=" "))
    A = anova(lm(as.numeric(as.factor(dat[,i])) ~ as.factor(dat[,10]))); p = A$"Pr(>F)"[1];   
    plot(as.factor(dat[,i]) ~ as.factor(dat[,10]), main=paste(colnames(dat)[i]," p=", signif(p,2)), ylab="", xlab="")
  }
  else{
    print(paste(i,"Number Graph",sep=" "))
    A = anova(lm(as.numeric(dat[,i]) ~ dat$RIN)); p = A$"Pr(>F)"[1];   
    plot(as.numeric(as.character(dat[,i])) ~ dat$RIN, main=paste(colnames(dat)[i]," p=", signif(p,2)), ylab="", xlab="")
  }
}

dev.off()

## Nothing significantly correlated based on ANOVA

## linear model

dat$RIN = as.factor(dat$RIN)
dat = dat[-grep("a",dat$RIN),]

RIN = as.numeric(as.character(dat$RIN))
Date = as.numeric(as.factor(dat$Dissection_Date))
Weight = as.numeric(as.character(dat$Weight))
Location = as.numeric(as.factor(dat$Location))
Diss = as.numeric(as.factor(dat$Dissector))
Order = as.numeric(as.character(dat$Run_Order))

mod = as.data.frame(cbind(RIN,Date,Weight,Location,Diss,Order))

RINmod = lm(RIN ~ Date + Weight + Location + Diss + Order,data=mod)
RINcoef = coef(RINmod)

#> summary(RINmod)
#
#Call:
#  lm(formula = RIN ~ Date + Weight + Location + Diss + Order, data = mod)
#
#Residuals:
#  Min      1Q  Median      3Q     Max 
#-2.4329 -1.0269 -0.3697  0.8222  4.4219 
#
#Coefficients:
#  Estimate Std. Error t value Pr(>|t|)  
#(Intercept) 10.887082   4.708569   2.312   0.0220 *
#  Date        -0.018055   0.021060  -0.857   0.3925  
#Weight      -5.544058   4.244310  -1.306   0.1933  
#Location    -0.045137   0.161903  -0.279   0.7808  
#Diss        -0.023808   0.137809  -0.173   0.8631  
#Order       -0.006620   0.003135  -2.112   0.0362 *
#  ---
#Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#
#Residual standard error: 1.444 on 164 degrees of freedom
#Multiple R-squared:  0.09941,  Adjusted R-squared:  0.07196 
#F-statistic: 3.621 on 5 and 164 DF,  p-value: 0.003919

######################################################################## Combine data from both waves

options(stringsAsFactors = FALSE)
setwd("C:/Users/Jill/Dropbox/DHGLab/ASDPan/expression/")

setwd("./wave1")

cuff1 = read.csv("Wave1exprs_Cuff.csv",row.names=1)
htgene1 = read.csv("Wave1exprs_HTSCgene.csv",row.names=1)
htexon1 = read.csv("Wave1exprs_HTSCexon.csv",row.names = 1)

setwd("../")
setwd("./wave2")

cuff2 = read.csv("Wave2exprs_Cuff.csv",row.names=1)
htgene2 = read.csv("Wave2exprs_HTSCgene.csv",row.names=1)
htexon2 = read.csv("Wave2exprs_HTSCexon.csv",row.names = 1)

cuff = cbind(cuff1,cuff2)
htgene = cbind(htgene1,htgene2)
htexon = cbind(htexon1,htexon2)

cols = colnames(cuff)
cols = substr(cols,2,10)

colnames(cuff) = substr(colnames(cuff),2,10)
colnames(htgene) = substr(colnames(htgene),2,10)
colnames(htexon) = substr(colnames(htexon),2,10)

setwd("../")
setwd("./all")

write.csv(cuff,file="Cufflinks.csv")
write.csv(htgene,file="HTSCgene.csv")
write.csv(htexon,file="HTSCexon.csv")










