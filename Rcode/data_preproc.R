setwd("C:/Users/acer/Desktop/PROS/Data/fMRI_PilotData")

library(ggplot2)
library(ggpubr)
library(gtools)

File.list = mixedsort(list.files("behaviorD"))
#list.files�R�O�Nbehavior��󧨤U�Ҧ����W��JFile.list

combined = paste("./behaviorD/", File.list, sep="")
#��paste�R�O�c�ظ��|�ܶqcombined

leng = length(combined)
#Ū��combined���סA�]�N�O��󧨤U�����Ӽ�

Subject.number =leng/6
#�C�Ө��ժ̦�6���ɮ�, �����i�o�X����ժ�

merge.data = read.csv(file = combined[ 1], header=T, sep=",")
#Ū�J�Ĥ@�Ӥ�󤺮e�]�i�H���Υ�Ū�@�ӡA���O���F²��A�٥h�w�qdata.frame���ɶ��A��ܥ�Ū�J�@�Ӥ��C

for (i in 2:leng){
  new.data = read.csv(file = combined[ i], header=T, sep=",")
  merge.data = rbind(merge.data,new.data)
}

behavior.df <- data.frame(merge.data)

############################## Adding columns ########################################

youngnum <- table(behavior.df$GroupN)[1]/64
oldnum <- table(behavior.df$GroupN)[2]/64
#calculate the subjects number in groups 

ncolbehavior.df <- ncol(behavior.df) #�p��column number

for (i in c(1:nrow(behavior.df))){
  behavior.df[i, ncolbehavior.df+1] <- behavior.df[i, 12] - behavior.df[i, 11] # MDRT  - MDFirstP = �������Ҫ������ɶ� ( 12 - 11 ) 
  behavior.df[i, ncolbehavior.df+2] <- behavior.df[i, 15] - behavior.df[i, 14] # EmoRT - EFirstP = ���������������ɶ� ( 15 - 14 )
  behavior.df[i, ncolbehavior.df+3] <- behavior.df[i, 27] - behavior.df[i, 22] # TrialEnd - fixOnsettime  = ITI duration = ITI ( 27 - 22 )
  behavior.df[i, ncolbehavior.df+4] <- behavior.df[i, 24] - behavior.df[i, 23] # ISIstart - MDOnsettime = �������Ҫ�duraiton ( 24 - 23 )
  behavior.df[i, ncolbehavior.df+5] <- behavior.df[i, 25] - behavior.df[i, 24] # EmoOnsettime  - ISIstart = ISI duration = ISI ( 25 - 24 )
  behavior.df[i, ncolbehavior.df+6] <- behavior.df[i, 26] - behavior.df[i, 25] # EmoEndtime - EmoOnsettime = ������ܪ�duration ( 26 - 25 )
  behavior.df[i, ncolbehavior.df+7] <- behavior.df[i, 27] - behavior.df[i,  5] # TrialEnd - TriggerS = �qTrigger�}�l����eTrial�������ɶ� ( 27 - 5 )
  
  if (i >= 2){ 
    behavior.df[i, ncolbehavior.df+8] <- behavior.df[i, ncolbehavior.df+7] - behavior.df[(i-1), ncolbehavior.df+7] #�@��Trial���`�ɶ�
  }
}

for (i in c(1:nrow(behavior.df))){
  behavior.df[i, ncolbehavior.df+9] <- behavior.df[i, 21] - behavior.df[i, 5] #LongFixation�`�ɶ�( 21 -5 )
  behavior.df[i, ncolbehavior.df+10] <- behavior.df[i, 19] + behavior.df[i, 20] + 24000 #default duartion per trial =  behavior.df[i, ncolbehavior.df+8]
}
behavior.df[1, ncolbehavior.df+8] <- behavior.df[1, ncolbehavior.df+7] - behavior.df[1, ncolbehavior.df+9] #�Ĥ@��Trial���`�ɶ�
colnames(behavior.df)[(ncolbehavior.df+1):(ncolbehavior.df+10)] <- c("MoneyD_RT", "EmoD_RT", "ITI_D", "MoneyD", "ISI_D","EmoD","DTriggerOnset","TrialD","LongD","DefaultT")
# adding tags



behavior.con <- behavior.df
behavior.con$SIT <- NULL 
behavior.con$EmoRESP <- NULL
write.csv(behavior.con, file = sprintf("behavior.CSV"),  row.names=FALSE)