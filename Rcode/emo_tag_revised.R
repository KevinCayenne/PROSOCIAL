setwd("C:/Users/acer/Desktop/PROS/Data/fMRI_PilotData")

## money regulation normalise

library(stats)
library(Matrix)
library(ggplot2)
library(ggpubr)
library(gtools)
library(gridExtra)
library(lme4)
library(lmerTest)
library(tidyr)
library(dplyr)
library(data.table)
library(reshape2)
library(plyr)
library(sjPlot)
library(sjmisc)

require(dplyr)

rawdf <- read.csv("behavior.CSV")
T.num <- length(rawdf$SubjectN)/64
ncolrawdf <- ncol(rawdf)

rawdf$GroupN <- as.factor(rawdf$GroupN)
rawdf$SITtag <- as.factor(rawdf$SITtag)

rawdf[,ncolrawdf+1] <- rawdf$RegMtag
rawdf[,ncolrawdf+2] <- rawdf$RegM - rawdf$giveM
colnames(rawdf)[ncol(rawdf)-1] <- c("rev_reg_M")
colnames(rawdf)[ncol(rawdf)] <- c("rev_dist")

for (i in c(2,3,5,6)){
  rawdf$RegMtag[rawdf$RegMtag==i & rawdf$RegM==300] <- 1
  rawdf$RegMtag[rawdf$RegMtag==i & rawdf$RegM==0] <- 7
}
rawdf$RegMtag[rawdf$RegMtag==1 & rawdf$giveM==300] <- 4
rawdf$RegMtag[rawdf$RegMtag==7 & rawdf$giveM==0] <- 4

Yg <- c()
Og <- c()

K <- tapply(rawdf$EmoTag, list(rawdf$SITtag, rawdf$RegMtag, rawdf$SubjectN, rawdf$GroupN), mean)

for(i in c(1:T.num)){
  if(is.na(K[,,,1][,,i][1]) != TRUE){
    Yg <- c(Yg, K[,,,1][,,i])
  }
  if(is.na(K[,,,2][,,i][1]) != TRUE){
    Og <- c(Og, K[,,,2][,,i])
  }
}

#### All ggline emotional section ####

youngnum <- length(Yg)/28
oldnum <- length(Og)/28
allnum <- youngnum + oldnum
all.emo.vector <- c(Yg, Og)

all.emo.group.tag <- as.factor(rep(c("Young","Old"),c((youngnum*28), (oldnum*28))))
all.emo.sit.tag <- as.factor(rep(c("PRO","PUR","NEU","UNC"), length(all.emo.vector)/4))
all.emo.tag <- as.factor(rep(rep(c("300", "+50", "+20", "same", "-20", "-50", "0"), c(4,4,4,4,4,4,4)), youngnum + oldnum))
all.subject.tag <- as.factor(rep(1:allnum, each = 28))
  
levels(all.emo.sit.tag) <- list(PRO = "PRO", PUR = "PUR", NEU = "NEU", UNC = "UNC")
levels(all.emo.group.tag) <- list(Young = "Young", Old = "Old")
levels(all.emo.tag) <- list("0" = "0", "-50" = "-50", "-20" = "-20", same = "same", "+20" = "+20", "+50" = "+50", "300" = "300")
 
all.emo.dataf <- data.frame(all.emo.vector, all.emo.group.tag, all.emo.sit.tag, all.emo.tag, all.subject.tag)
is.na(all.emo.vector)
all.emo.dataf <- all.emo.dataf[!is.na(all.emo.vector),]

all.emo.dataf <- rbind(all.emo.dataf, c(as.numeric(0), "Young", "NEU", "-50", 1), c(as.numeric(0), "Old", "UNC", "-50", 29))
all.emo.dataf$all.emo.vector<- as.numeric(all.emo.dataf$all.emo.vector)

all.emo.dataf.p <- all.emo.dataf[(-nrow(all.emo.dataf)):(-nrow(all.emo.dataf)+1),]
all.emo.dataf.p$all.emo.vector <- all.emo.dataf.p$all.emo.vector
str(all.emo.dataf.p)

png(sprintf("RT_boxplot_ALL.png"), width = 1800, height = 1000)  
  ggline(all.emo.dataf, x = "all.emo.tag", y = "all.emo.vector", add = c("mean_se", "jitter"), size = 1,
         color = "all.emo.group.tag", palette = "jco", position = position_dodge(1.8), facet.by = "all.emo.sit.tag") +
    labs(title = "Group difference in emotion rating",
         x = "Money regulation type", y = "Emotional rate", colour = "Group") +
    stat_compare_means(aes(group = all.emo.group.tag), label = "p.signif",
                       label.y = 4.5) +
    geom_hline(yintercept = 0) +
    theme(plot.title = element_text(hjust = 0.5),
          title = element_text(size=25),
          legend.text = element_text(size=20),
          legend.title = element_text(size=20),
          axis.text = element_text(size=15),
          axis.title = element_text(size=15,face="bold")
    )
dev.off()

ggbarplot(all.emo.dataf, x = "all.emo.tag", y = "all.emo.vector", add = c("mean_se", "jitter"), size = 1,
       color = "all.emo.group.tag", palette = "jco", position = position_dodge(0.8), facet.by = "all.emo.sit.tag") +
  labs(title = "Group difference in emotion rating",
       x = "Money regulation type", y = "Emotional rate", colour = "Group") +
  stat_compare_means(aes(group = all.emo.group.tag), label = "p.signif",
                     label.y = 4.5) +
  geom_hline(yintercept = 0) +
  theme(plot.title = element_text(hjust = 0.5),
        title = element_text(size=25),
        legend.text = element_text(size=20),
        legend.title = element_text(size=20),
        axis.text = element_text(size=15),
        axis.title = element_text(size=15,face="bold")
  )

all.emo.se <- rep(NA,56)
all.emo.sd <- ldply(tapply(all.emo.dataf$all.emo.vector, list(all.emo.dataf$all.emo.group.tag, all.emo.dataf$all.emo.tag, all.emo.dataf$all.emo.sit.tag), sd))
all.emo.se[seq(1,55,2)] <- all.emo.sd[seq(1,55,2),]/sqrt(youngnum)
all.emo.se[seq(2,56,2)] <- all.emo.sd[seq(2,56,2),]/sqrt(oldnum)

bar.emo.mean.df <- aggregate(all.emo.dataf$all.emo.vector, list(all.emo.dataf$all.emo.group.tag, all.emo.dataf$all.emo.tag, all.emo.dataf$all.emo.sit.tag), mean)
bar.emo.mean.df <- cbind(bar.emo.mean.df, all.emo.se)
colnames(bar.emo.mean.df) <- c("Group", "M_reg", "Sit", "mean_emo", "se_emo")

ggplot(data = bar.emo.mean.df, aes(x = M_reg, y = mean_emo)) +
        geom_bar(aes(fill = Group, group = Group),
                 stat = 'identity', position = position_dodge(), color="black")  +
        geom_errorbar(aes(ymin=mean_emo-all.emo.se, ymax=mean_emo+all.emo.se, group = Group), colour="black", width=.3, position=position_dodge(width=.9)) +
        facet_grid( ~ Sit, scale='free_x') +
  
        labs(title = "Group difference in emotion rating",
             x = "Money regulation type", y = "Emotional rate", colour = "Group") +
  
        theme(plot.title = element_text(hjust = 0.5),
        title = element_text(size=20),
        legend.text = element_text(size=15),
        legend.title = element_text(size=15),
        axis.text = element_text(size=12),
        axis.title = element_text(size=15,face="bold")
        )
        
bb <- lmer(all.emo.vector ~ all.emo.tag*all.emo.sit.tag*all.emo.group.tag + I(all.emo.tag^2) + 
             (1+|all.subject.tag) 
             data = all.emo.dataf.p)

anova(bb)
summary(bb)

###
# rawdf$rev_dist[rawdf$rev_dist==0]

rawdf[ncol(rawdf)+1] <- rawdf$rev_dist
colnames(rawdf)[ncol(rawdf)] <- c("rev_dist_tag")
#rawdf$rev_dist_tag[rawdf$rev_dist_tag==0] <- 0

iter <- -1
for(i in seq(0,-250,-50)){
  print(iter)
  print(rawdf$rev_dist_tag[rawdf$rev_dist_tag>=i-50 & rawdf$rev_dist_tag < i])
  rawdf$rev_dist_tag[rawdf$rev_dist_tag>=i-50 & rawdf$rev_dist_tag < i] <- iter
  iter <- iter - 1
}

iter <- 1
for(i in seq(0,250,50)){
  rawdf$rev_dist_tag[rawdf$rev_dist_tag>=i & rawdf$rev_dist_tag < i+50] <- iter
  iter <- iter + 1
}
rawdf$rev_dist_tag[rawdf$rev_dist==300] <- 7
rawdf$rev_dist_tag[rawdf$rev_dist==-300] <- -7

rawdf$rev_dist_tag[rawdf$rev_dist==0] <- 0

E <- tapply(rawdf$EmoTag, list(rawdf$SITtag, rawdf$rev_dist_tag, rawdf$SubjectN, rawdf$GroupN), mean)
YgE <- c()
OgE <- c()

for(i in c(1:T.num)){
  if(is.na(E[,,,1][,,i][1,6]) != TRUE){
    YgE <- c(YgE, E[,,,1][,,i])
  }
  if(is.na(E[,,,2][,,i][1,6]) != TRUE){
    OgE <- c(OgE, E[,,,2][,,i])
  }
}

T.E <- c(YgE, OgE)

# length(T.E)
#hist(rawdf$rev_dist_tag)

all.emo.group.tag.R <- as.factor(rep(c("Young","Old"),c((youngnum*52), (oldnum*52))))
all.emo.sit.tag.R <- as.factor(rep(c("PRO","PUR","NEU","UNC"), length(T.E)/4))
all.emo.tag.R <- as.factor(rep(rep(c("-7", "-4", "-3", "-2", "-1", "0", "1", "2", "3", "4", "5", "6","7"), c(4,4,4,4,4,4,4,4,4,4,4,4,4)), T.num))

levels(all.emo.sit.tag.R) <- list(PRO = "PRO", PUR = "PUR", NEU = "NEU", UNC = "UNC")
levels(all.emo.group.tag.R) <- list(Young = "Young", Old = "Old")
levels(all.emo.tag.R) <- list("-7" = "-7", "-5" = "-5", "-4" = "-4", "-3" = "-3", "-2" = "-2", "-1" = "-1", "0" = "0", "1" = "1", "2" = "2", "3" = "3", "4" = "4", "5" = "5", "6" = "6", "7" = "7")

length(all.emo.group.tag.R)

all.emo.dataf.R <- data.frame(T.E, all.emo.group.tag.R, all.emo.sit.tag.R, all.emo.tag.R)

levels(rawdf$GroupN) <- list("Young" = "1", "Old" = "2")
levels(rawdf$SITtag) <- list("PRO" = "1", "PUR" = "2", "NEU" = "3", "UNC" = "4")
# all.emo.dataf.R[!is.na(T.E),]

# ggline(all.emo.dataf.R, x = "all.emo.tag.R", y = "T.E", add = c("mean_se", "jitter"),
#        color = "all.emo.group.tag.R", palette = "jco", facet.by = "all.emo.sit.tag.R") +
#   labs(title = "Group difference in emotion choices by groups",
#        x = "Money regulation type", y = "Emotional rate", colour = "Group") +
#   theme(plot.title = element_text(hjust = 0.5, size= 15)) +
#   stat_compare_means(aes(group = all.emo.group.tag.R), label = "p.signif",
#                      label.y = 4.5) +
#   geom_hline(yintercept = 0) +
#   geom_vline(xintercept = 0)

ggplot(data = rawdf, aes(x = EmoTag, y = rev_dist, colour = GroupN, group = GroupN)) +
  geom_point() +
  geom_smooth(method = 'lm', formula = y ~ poly(x,2)) +
  facet_grid(~ SITtag)  

# tapply(rawdf$rev_dist, list(rawdf$GroupN, rawdf$SITtag))
levels(rawdf$GroupN) <- list(Young = "Young", Old = "Old")
levels(rawdf$SITtag) <- list(PRO = "PROS", PUR = "PUR", NEU = "NEU", UNC = "UCN")
  
emo.lmer.qua <- lmer(EmoTag ~ GroupN*SITtag*poly(rev_dist, 2, raw = TRUE) +
                       (1+SITtag+rev_dist+poly(rev_dist, 2, raw = TRUE)|SubjectN), data = rawdf)

emo.lmer.qua.slope <- lmer(EmoTag ~ GroupN*SITtag*poly(rev_dist, 2, raw = TRUE) +
                       (1+SITtag+rev_dist|SubjectN), data = rawdf)
options(contrasts=c("contr.sum", "contr.poly"))
anova(emo.lmer.qua, emo.lmer.qua.slope)

emo.lmer <- lmer(EmoTag ~ GroupN*SITtag*rev_dist +
                   (1+SITtag|SubjectN),
                 data = rawdf)

summary(emo.lmer.qua.slope)
anova(emo.lmer.qua.slope)
Anova(emo.lmer.qua.slope, type = c("III"))

positive.emo <- rawdf[rawdf$rev_dist >= 0 ,]
negative.emo <- rawdf[rawdf$rev_dist < 0 & rawdf$rev_dist >= -150,]

rawdf.Y <- rawdf[rawdf$GroupN == "Young",]
rawdf.O <- rawdf[rawdf$GroupN == "Old",]

emolmer.pos <- lmer(log(EmoTag+5) ~ GroupN*SITtag*poly(rev_dist, 2, raw = TRUE) + 
                      (1+GroupN+SITtag|SubjectN), data = positive.emo)
summary(emolmer.pos)
anova(emolmer.pos)
str(positive.emo)

emolmer.neg <- lmer(log(EmoTag+5) ~ GroupN*SITtag*poly(rev_dist, 2, raw = TRUE) + 
                      (1+GroupN+SITtag|SubjectN), data = negative.emo)
summary(emolmer.neg)
anova(emolmer.neg)

par(mfrow = c(2,2))
plot(emo.lmer.qua.slope, EmoTag ~ fitted(.)| SITtag*GroupN, type = c("p", "smooth") , id = 0.05)
plot(emo.lmer.qua.slope, resid(., scaled=TRUE) ~ fitted(.)| SITtag*GroupN, type = c("p", "smooth") )
plot(emo.lmer.qua.slope, EmoTag ~ fitted(.)| SITtag*GroupN, type = c("p", "smooth") , id = 0.05)
plot(emo.lmer.qua.slope, resid(., scaled=TRUE) ~ fitted(.)| SITtag*GroupN)

require("lattice")
plot(emo.lmer.qua.slope, type = c("p", "smooth") , id = 0.05)
plot(emo.lmer.qua.slope, sqrt(abs(resid(.))) ~ fitted(.) | GroupN*SITtag, abline=c(h = 0),type = c("p", "smooth"), id = 0.05)
lattice::dotplot(ranef(emo.lmer.qua.slope, condVar=TRUE))
plot(emolmer.neg, type = c("p", "smooth") , id = 0.05)
plot(emolmer.neg, sqrt(abs(resid(.))) ~ fitted(.) | GroupN*SITtag, abline=c(h = 0),type = c("p", "smooth"), id = 0.05)
lattice::dotplot(ranef(emolmer.neg, condVar=TRUE))

qqmath(emo.lmer.qua.slope, id=0.05)

emolmer.Y <- lmer(EmoTag ~ SITtag*poly(rev_dist, 2, raw = TRUE) + 
       (1|SubjectN), data = rawdf.Y)

sumemo.Y <- summary(lmer(EmoTag ~ SITtag*poly(rev_dist, 2, raw = TRUE) + 
                    (1+SITtag+rev_dist|SubjectN), data = rawdf.Y))

sumemo.O <- summary(lmer(EmoTag ~ SITtag*poly(rev_dist, 2, raw = TRUE) + 
                    (1+SITtag+rev_dist|SubjectN), data = rawdf.O))

anova(lmer(EmoTag ~ SITtag*poly(rev_dist, 2, raw = TRUE) + 
             (1+SITtag+rev_dist|SubjectN), data = rawdf.Y))

anova(lmer(EmoTag ~ SITtag*poly(rev_dist, 2, raw = TRUE) + 
             (1+SITtag+rev_dist|SubjectN), data = rawdf.O))

ggplot(data = rawdf, aes(x = rev_dist, y = EmoTag, group = GroupN)) +
  geom_point(aes(colour = GroupN), size = 2) +
  geom_smooth(method = 'lm', formula = y ~ poly(x,2), aes(colour = GroupN), size=2) +
  facet_grid(~ SITtag) +
  theme_bw() +
  labs(x = "Distance from origin money decision (normalised)", y = "Emotion Reaction", 
       colour = "Groups", fill = "Group") +
  theme(plot.title = element_text(hjust = 0.5),
        title = element_text(size=30, face="bold"),
        legend.text = element_text(size=35),
        legend.title = element_text(size=35),
        axis.text = element_text(size=35),
        axis.title = element_text(size=35,face="bold"),
        text = element_text(size=35),
        legend.position = "none"
  ) +
  scale_colour_manual(values = c("#0075C9","#E5BF21")) +
  ylim(c(-3,4))

####
ggplot(data = positive.emo, aes(x = rev_dist, y = EmoTag, group = GroupN)) +
  geom_point(aes(colour = GroupN), size = 2) +
  geom_smooth(method = 'lm', formula = y ~ poly(x,1), aes(colour = GroupN), size=2) +
  facet_grid(~ SITtag) +
  theme_bw() +
  labs(x = "Distance from origin money decision (normalised)", y = "Emotion Reaction", 
       colour = "Group", fill = "Group") +
  theme(plot.title = element_text(hjust = 0.5),
        title = element_text(size=30, face="bold"),
        legend.text = element_text(size=35),
        legend.title = element_text(size=35),
        axis.text = element_text(size=35),
        axis.title = element_text(size=35,face="bold"),
        text = element_text(size=35),
        legend.position = "none"
  ) +
  scale_colour_manual(values = c("#0075C9","#E5BF21")) +
  ylim(c(-3,4))

ggplot(data = negative.emo, aes(x = rev_dist, y = EmoTag, group = GroupN)) +
  geom_point(aes(colour = GroupN), size = 2) +
  geom_smooth(method = 'lm', formula = y ~ poly(x,1), aes(colour = GroupN), size=2) +
  facet_grid(~ SITtag) +
  theme_bw() +
  labs(x = "Distance from origin money decision (normalised)", y = "Emotion Reaction", 
       colour = "Group", fill = "Group") +
  theme(plot.title = element_text(hjust = 0.5),
        title = element_text(size=30, face="bold"),
        legend.text = element_text(size=35),
        legend.title = element_text(size=35),
        axis.text = element_text(size=35),
        axis.title = element_text(size=35,face="bold"),
        text = element_text(size=35),
        legend.position = "none"
  ) +
  scale_colour_manual(values = c("#0075C9","#E5BF21")) +
  ylim(c(-3,4))


ggplot(data = rawdf, aes(x = rev_dist, y = EmoTag, colour = GroupN, group = GroupN)) +
  geom_point() +
  geom_smooth(method = 'lm') +
  facet_grid(~ SITtag)

E.T <- tapply(rawdf$EmoTag, list(rawdf$SITtag, rawdf$SubjectN, rawdf$GroupN), mean)
# E.T
# length(na.omit(as.vector(E.T)))
  
tapply(all.emo.dataf$all.emo.vector, list(all.emo.dataf$all.emo.group.tag, all.emo.dataf$all.emo.sit.tag, all.emo.dataf$all.emo.tag), mean)
tapply(all.emo.dataf$all.emo.vector, list(all.emo.dataf$all.emo.group.tag, all.emo.dataf$all.emo.sit.tag, all.emo.dataf$all.emo.tag), sd)

##

multicom <- compare_means(all.emo.vector ~ all.emo.sit.tag, data = all.emo.dataf.o, group.by = c("all.emo.tag", "all.emo.group.tag"), method = "t.test")
multicom.label <- list(c("PRO", "PUR"))

ggbarplot(all.emo.dataf.o, x = "all.emo.sit.tag", y = "all.emo.vector", add = c("mean_se", "jitter"),
       color = "all.emo.tag", palette = "jco", facet.by = "all.emo.group.tag", size=2, position = position_dodge(0.8)) +
  labs(title = "Group difference in emotion choices by groups", x = "Money regulation type", y = "Emotion Reaction", colour = "Group") +   
  theme(plot.title = element_text(hjust = 0.5, size= 30)) +
  stat_compare_means(comparisons = multicom.label , label = "p.signif", 
                     label.y = 4.5, size = 1) +
  geom_hline(yintercept = 0) +
  
  theme(plot.title = element_text(hjust = 0.5),
        title = element_text(size=30, face="bold"),
        legend.text = element_text(size=30),
        legend.title = element_text(size=30),
        axis.text = element_text(size=20),
        axis.title = element_text(size=30,face="bold"),
        text = element_text(size=30)
  )

######

ter.Y <- aggregate(list(rawdf.Y$rev_dist, rawdf.Y$EmoTag), list(rawdf.Y$SubjectN, rawdf.Y$RegMtag, rawdf.Y$SITtag), mean, drop=FALSE)
colnames(ter.Y) <- c("sub.tag", "reg.tag", "sit.tag", "dist", "value")
ter.Y$dist[is.na(ter.Y$dist)] <- 0
ter.Y$value[is.na(ter.Y$value)] <- 0

ter.O <- aggregate(list(rawdf.O$rev_dist, rawdf.O$EmoTag), list(rawdf.O$SubjectN, rawdf.O$RegMtag, rawdf.O$SITtag), mean, drop=FALSE)
colnames(ter.O) <- c("sub.tag", "reg.tag", "sit.tag", "dist", "value")
ter.O$dist[is.na(ter.O$dist)] <- 0
ter.O$value[is.na(ter.O$value)] <- 0

ter.Y <- ter.Y[ter.Y$sit.tag == "PRO" | ter.Y$sit.tag == "PUR",]
ter.O <- ter.O[ter.O$sit.tag == "PRO" | ter.O$sit.tag == "PUR",]

ter.Y <- cbind(ter.Y, group.tag = rep("Young", nrow(ter.Y)))
ter.O <- cbind(ter.O, group.tag = rep("Old", nrow(ter.O)))

ter <- rbind(ter.Y, ter.O)
ter <- cbind(ter, signalval = sig.er.ter$x)

ggscatter(ter, x = "value", y = "signalval", 
          conf.int = TRUE, 
          cor.method = "pearson",
          cor.coef = TRUE, color = "group.tag", facet.by = c("sit.tag","group.tag"), palette = "jco",
          size=1, add.params = list(group = "group.tag")) +
  geom_smooth(method = 'lm', formula = y ~ poly(x,1), aes(colour = group.tag), size=2) 

# ggscatter(ter, x = "dist", y = "value", 
#           conf.int = TRUE, 
#           cor.method = "pearson",
#           cor.coef = TRUE, color = "group.tag", facet.by = c("sit.tag","group.tag"), palette = "jco",
#           size=1, add.params = list(group = "group.tag")) +
#   geom_smooth(method = 'lm', formula = y ~ poly(x,1), aes(colour = group.tag), size=2) 

ggline(ter, x = "reg.tag", y = "signalval", 
          add = c("mean_se"), color = "group.tag", facet.by = c("sit.tag"), palette = "jco",
          size=1, add.params = list(group = "group.tag")) + 
      stat_compare_means(aes(group = group.tag), label = "p.signif", 
                         label.y = 3)
