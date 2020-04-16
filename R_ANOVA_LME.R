# Load libraries for LME and Convenience functions for regression
library(lme4)
library(arm)
library(ez)
library(dplyr)
library(lmerTest)
library(effects)
library(ggplot2)

# Load data from directory
Data <- read.csv("/Volumes/G/Anon_Data_April_2020.csv", header = TRUE, sep = ",")

# Summary of data
head(Data)


# Removing if individual trial not acceptable due to noise, 1st trial, etc.
test <- filter(test, ALLOW == 1)

# Removing participants if
#  Filter_sig_dif_base == 0 (removes participants with significantly different base)
#  Filter_insuff_data == 0 (removes participants with insufficient data (<30/timepoint/condition))
#  FILTER == 0 (if either of the above are true (leftover from SPSS))
test2 <- filter(Data, Filter_sig_dif_base == 0)


# Ordering data structure, re-leveling & defining items as factors
test2[, 'Stimulus'] <- as.factor(test2[, 'Stimulus']) 
test2[, 'Timepoint'] <- as.factor(test2[, 'Timepoint']) 
test2[, 'Study_Group'] <- as.factor(test2[, 'Study_Group'])

# Set references to compare to
#  Stimulus "1" = Motor imagery of speech condition
#  Stimulus "2" = unused
#  Stimulus "3" = Hearing condition
#  Stimulus "4" = Baseline condition

test2$Stimulus <- relevel(test2$Stimulus, ref = "1")  
test2$Timepoint <- relevel(test2$Timepoint, ref = "200")


# Models using MEP_AUC as DV - use for MEP time window
baseline_model <- lmer(MEP_AUC ~ (1|Participant), data = test2)
group_model <-lmer(MEP_AUC ~ Study_Group + (1|Participant), data = test2)
stimulus_model <- lmer(MEP_AUC ~ Stimulus + (1|Participant), data = test2)
timepoint_model <- lmer(MEP_AUC ~ Timepoint + (1|Participant), data = test2)
mod1 <- lmer(MEP_AUC ~ Stimulus + Timepoint + (1|Participant), data = test2)
mod2 <- lmer(MEP_AUC ~ Stimulus * Timepoint + (1|Participant), data = test2)
mod3 <- lmer(MEP_AUC ~ Stimulus * Timepoint + Study_Group + (1|Participant), data = test2)
mod4 <- lmer(MEP_AUC ~ Stimulus * Timepoint * Study_Group + (1|Participant), data = test2)

# Models using SBase_AUC as DV - use for pre-MEP time window
baseline_model <- lmer(SBase_AUC ~ (1|Participant), data = test2)
group_model <-lmer(SBase_AUC ~ Study_Group + (1|Participant), data = test2)
stimulus_model <- lmer(SBase_AUC ~ Stimulus + (1|Participant), data = test2)
timepoint_model <- lmer(SBase_AUC ~ Timepoint + (1|Participant), data = test2)
mod1 <- lmer(SBase_AUC ~ Stimulus + Timepoint + (1|Participant), data = test2)
mod2 <- lmer(SBase_AUC ~ Stimulus * Timepoint + (1|Participant), data = test2)
mod3 <- lmer(SBase_AUC ~ Stimulus * Timepoint + Study_Group + (1|Participant), data = test2)
mod4 <- lmer(SBase_AUC ~ Stimulus * Timepoint * Study_Group + (1|Participant), data = test2)

# ANOVA comparisons of models
anova(baseline_model,group_model) # Is the group model better than the baseline model? 
anova(baseline_model, stimulus_model) # Is the stimulus (main eff) model better than baseline? 
anova(baseline_model, timepoint_model) # Is timepoint (main eff) model better than baseline? )
anova(baseline_model, mod1) # Is model with stim and timepoint better than baseline? 
anova(mod1, mod2) # Is model with interaction better than combo of stim and timepoint? 
anova(mod2,mod3) # Is model with interaction + Group better than two-way interaction? 
anova(mod3,mod4) # Is model with three-way interaction better than model with interaction  + Group? 

# Get relevant summaries
summary(baseline_model)
summary(stimulus_model)
summary(mod1)
summary(mod2)

#### Graphing model outcomes
ef <- effect("Stimulus * Timepoint", mod2)
x <- as.data.frame(ef)

ggplot(x, aes(Timepoint, fit, color = Stimulus)) +
  geom_point() +
  geom_errorbar(aes(ymin = fit - se, ymax = fit + se, width = .4)) +
  #geom_line() +
  facet_wrap(~Stimulus) +
  theme_bw()
