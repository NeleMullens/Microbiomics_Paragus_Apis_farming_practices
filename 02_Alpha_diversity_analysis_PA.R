# Alpha diversity --------------------------------------------------------------

## Calculate diversity indices -------------------------------------------------
# import normalized data 

freq_data <- read.csv("outputs/Frequency_table.csv", row.names=1)
freq_data <- read.csv("outputs/Aldex2/Genera/Input_genera_PA.csv", row.names=1) 

## Shannon
data_shannon <- diversity(t(freq_data), index = "shannon")
head(data_shannon)
write.table(data_shannon, "outputs/Alpha_diversity/alpha_diversity.xlsx", sheetName = "Shannon", 
            col.names = TRUE, row.names = TRUE, append = TRUE)
write.xlsx(data_shannon, "outputs/Alpha_diversity/alpha_diversity_gen.xlsx", sheetName = "Shannon", 
           col.names = TRUE, row.names = TRUE, append = TRUE)

## Inverse Simpson
data_invsimpson <- diversity(t(freq_data), index = "invsimpson")
head(data_invsimpson)
write.table(data_invsimpson, "outputs/Alpha_diversity/alpha_diversity.xlsx", sheetName = "Inverse_Simpson", 
            col.names = TRUE, row.names = TRUE, append = TRUE)

write.xlsx(data_invsimpson, "outputs/Alpha_diversity/alpha_diversity_gen.xlsx", sheetName = "Inverse_Simpson", 
           col.names = TRUE, row.names = TRUE, append = TRUE)

## ACE
AceIndex <- estimateR(t(freq_data))
write.table(AceIndex,file="outputs/Alpha_diversity/alpha_diversity.xlsx", sheetName = "ACE", 
            col.names = TRUE, row.names = TRUE, append = TRUE)
write.xlsx(AceIndex,file="outputs/Alpha_diversity/alpha_diversity_gen.xlsx", sheetName = "ACE", 
           col.names = TRUE, row.names = TRUE, append = TRUE)

## PD
library(phytools)
library("phyloseq")

phyl_tree <- ape::read.nexus("outputs/Hoverflies_microbiome.nex")
phyl_tree_rooted <- midpoint.root(phyl_tree)

Faith <- pd(t(freq_data), phyl_tree_rooted)
write.table(Faith, "outputs/Alpha_diversity/alpha_diversity.xlsx", sheetName = "PD", 
            col.names = TRUE, row.names = TRUE, append = TRUE)

write.xlsx(Faith, "outputs/Alpha_diversity/alpha_diversity_gen.xlsx", sheetName = "PD", 
           col.names = TRUE, row.names = TRUE, append = TRUE)

#Combine diversity indices in one file: outputs/Alpha_diversity/Diversity_indices_hoverflies.csv

# First look:
library(ggpubr)
divdat <- read.csv("outputs/Alpha_diversity/Diversity_indices_hoverflies.csv")

ggboxplot(divdat, x = "Species", y= "ACE", color = "black", fill = "Species")
ggboxplot(divdat, x = "Species", y= "Shannon", color = "black", fill = "Species")
ggboxplot(divdat, x = "Species", y= "inverse_simpson", color = "black", fill = "Species")
ggboxplot(divdat, x = "Species", y= "PD", color = "black", fill = "Species")


# Linear mixed models ----------------------------------------------------------
#compare differences in alpha diversity within and between species

## Tested on ASV's -------------------------------------------------------------
#divdat_PA <- read.csv("outputs/Alpha_diversity/Diversity_indices_hoverflies_PA.csv") # dataset with species as species
divdat_PA <- read.csv("outputs/Alpha_diversity/Diversity_indices_hoverflies_PAS.csv") # dataset with species as "groups": Paragus borbonicus male and female each as a different group


## Shannon -----
#go from complex model to simplified model, drop all non-significant interactions and random factor
lm.H.PA <-lmer(Shannon~ Species + 
                 Management +
                 Altitude + 
                 Species:Management +
                 Altitude:Management +
                 Altitude:Species +
                 (1|Field),
               data=divdat_PA)

anova(lm.H.PA,ddf="Satterthwaite",type=3)

# isSingular, remove random factor and switch to lm
lm.H.PA <-lm(Shannon~ Species + 
                 Management +
                 Altitude + 
                 Species:Management +
                 Altitude:Management +
                 Altitude:Species,
               data=divdat_PA)


summary(lm.H.PA)

# simplify model: remove insignificant interactions. 
# final model
lm.H.PA <-lm(Shannon~ Species + 
               Management +
               Altitude,
             data=divdat_PA)

# where do we see significance?
summary(lm.H.PA)

# significances between the three "species" groups (male and female P. borbonicus and A. mellifera)
emmeans(lm.H.PA, pairwise~Species, lmer.df = "Satterthwaite")

# which direction is the difference between species?
emmeans(lm.H.PA, ~Species)

## inverse simpson -----

lm.IS.PA <-lmer(inverse_simpson~ Species + 
                  Management +
                  Altitude + 
                  Species:Management +
                  Altitude:Management +
                  Altitude:Species +
                  (1|Field),
                data=divdat_PA)

# simplify model: remove insignificant interactions. 
# final model
lm.IS.PA <-lmer(inverse_simpson~ Species + 
                  Management +
                  Altitude + 
                  (1|Field),
                data=divdat_PA)


anova(lm.IS.PA,ddf="Satterthwaite",type=3)

summary(lm.IS.PA)

# significances between the three "species" groups (male and female P. borbonicus and A. mellifera)
emmeans(lm.IS.PA, pairwise~Species, lmer.df = "Satterthwaite")

# which direction is the difference between species?
emmeans(lm.IS.PA, ~Species)

## ACE -----

#error: Model may not have converged with 1 eigenvalue close to zero: 1.0e-13
#standardize data:
divdat_PA_st <- divdat_PA %>% mutate_at(c('S.ACE'), ~(scale(.) %>% as.vector))

lm.ACE.PA <-lmer(S.ACE~ Species + 
                   Management +
                   Altitude + 
                   Species:Management +
                   Altitude:Management +
                   Altitude:Species +
                   (1|Field),
                 data=divdat_PA_st)

anova(lm.ACE.PA,ddf="Satterthwaite",type=3)

summary(lm.ACE.PA)

# simplify model: remove insignificant interactions. 
# final model
lm.ACE.PA <-lmer(S.ACE~ Species + 
                   Management +
                   Altitude +
                   (1|Field),
                 data=divdat_PA_st)

anova(lm.ACE.PA,ddf="Satterthwaite",type=3)

summary(lm.ACE.PA)

# significances between the three "species" groups (male and female P. borbonicus and A. mellifera)
emmeans(lm.ACE.PA, pairwise~Species, lmer.df = "Satterthwaite")

# which direction is the difference between species?
emmeans(lm.ACE.PA, ~Species)

## PD -----


lm.PD.PA <-lmer(PD~ Species + 
                  Management +
                  Altitude + 
                  Species:Management +
                  Altitude:Management +
                  Altitude:Species +
                  (1|Field),
                data=divdat_PA)

anova(lm.PD.PA,ddf="Satterthwaite",type=3)

summary(lm.PD.PA)

# simplify model: remove insignificant interactions. 
# final model
lm.PD.PA <-lmer(PD~ Species + 
                  Management +
                  Altitude + 
                  Altitude:Species +
                  (1|Field),
                data=divdat_PA)

anova(lm.PD.PA,ddf="Satterthwaite",type=3)

summary(lm.PD.PA)

# significances between the three "species" groups (male and female P. borbonicus and A. mellifera)
emmeans(lm.PD.PA, pairwise~Altitude:Species, lmer.df = "Satterthwaite")
emmeans(lm.PD.PA, pairwise~Species, lmer.df = "Satterthwaite")
emmeans(lm.PD.PA, ~Altitude:Species)
emmeans(lm.PD.PA, ~Species)

#visualise

ggboxplot(divdat_PA, x = "Sex", y= "PD", color = "black", fill = "Altitude")
ggboxplot(divdat_PA, x = "Species", y= "PD", color = "black", fill = "Altitude")