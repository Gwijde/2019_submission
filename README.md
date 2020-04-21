# 2019_NeuroIm
Data and source files for (insert link and DOI here)

## Anonymised data
Anonymised data for this study is available as a CSV [here](./Anon_Data_April_2020.csv). This dataset has been altered to adhere to GDPR guidelines.

## SPSS Syntax (limited)
SPSS syntax for preliminary data configuration is available [here](./GitHub_Syntax.sps). Please be aware some sections have been redacted for GDPR purposes.

## R analysis code
The R analysis code for this study is available [here](./R_ANOVA_LME.R).

This file is in fact an SPSS out-file and as such contains several variables not absolute necessary for use in R, such as `FILTER` which is just a disjunction (OR) of `Filter_insuff_data` and `Filter_sig_dif_base` effected in SPSS syntax.

### Variables
A description of variables used and their logical coding. As mentioned, some variables are not strictly speaking necessary but were calculated using SPSS syntax (e.g. `ALLOW` is 0 in certain logical cases, but also iff trial `MEP_AUC` exceeds 3SDs from participants' individual mean as calculated in SPSS. Your mileage may vary slighly if performing each operation in R from raw data). 

* `MEP`- individual MEP number for that participant, 1 - 240 in chronological succession
* `Part_Anon`- Anonymised Participant data
* `Stimulus`- Stimuli/condition as follows:
    * `1` - Motor imagery of speech condition
    * `2` - unused
    * `3` - Hearing condition
    * `4` - Baseline condition
* `Timepoint`- Pulse timepoint post-cue as follows:
    * `200` - 200ms post-cue
    * `500` - 500ms post-cue
* `Study_Group` - Denotes whether participant is part of 
    * `100`- Group A (100% aMT)
    * `120`- Group B (120% aMT)
* `MEP_P2P`- Peak-to-peak values for MEPs for additional inspection, if desired
* `MEP_AUC`- Area-under-the-curve values for MEPs for main analysis
* `SBase_P2P`- Peak-to-peak values for pre-MEP pulse window to check baseline muscle activation
* `SBase_AUC`- Area-under-the-curve values for pre-MEP pulse window to check baseline muscle activation
* `Target/Angular/Twist Error`- Distance/angle/twist values from TMS target as reported by Brainsight
* `Allow_1st_Trial`- Boolean value for inclusion in analysis, 0 if first trial in a block
* `Allow_Loc_Error`- Boolean value for inclusion in analysis, 0 if Target/Angular/Twist Error exceeeds pre-determined values
* `Allow_MEP` - Boolean value for inclusion in analysis, 0 if manual visual check finds noise/flatline in MEP window
* `ALLOW` - Boolean value for inclusion in analysis, 0 if any of `Allow_1st_Trial`, `Allow_Loc_Error` or `Allow_MEP` are 0. Additionally, 0 if `MEP_AUC` exceeds 3SDs from the participant's mean.
* `Filter_insuff_data`- Boolean value for inclusion in analysis, 0 if insufficient data (<30 MEPs/ timepoint/condition/participant)
* `Filter_sig_dif_base` - Boolean value for inclusion in analysis, 0 if pre-MEP muscle activation is significantly different across conditions (based on SBase_AUC)
* `FILTER` - Boolean value for inclusion in analysis, 0 if either `Filter_sig_dif_base` or `Filter_insuff_data` are 0

All analysis as presented in the paper were performed using R and `lme4`, with standard additional packages, such as `dplyr`also used (see preamble for details). Many thanks to Tony Trotter and Max Paulus for their help in transitioning the data from SPSS to R, and their help in configuring the analysis appropriately.
