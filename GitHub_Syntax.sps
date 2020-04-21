* Encoding: UTF-8.

*FILTER SECTION:
    - 1st trial exlusion;
    - Location error exclusion;
    - MEP manual check

* 1st trial of block MEPs are always larger, exclude.

COMPUTE Allow_1st_Trial = 1.
IF MEP = 1 Allow_1st_Trial = 0.
IF MEP = 31 Allow_1st_Trial = 0.
IF MEP = 61 Allow_1st_Trial = 0.
IF MEP = 91 Allow_1st_Trial = 0.
IF MEP = 121 Allow_1st_Trial = 0.
IF MEP = 151 Allow_1st_Trial = 0.
IF MEP = 181 Allow_1st_Trial = 0.
IF MEP = 211 Allow_1st_Trial = 0.
EXECUTE.


*If Target Error / Angular error / Twist Error exceed allowance, exclude.

COMPUTE Allow_Loc_Error = 1.
IF (Target_Error >2 | Angular_Error > 10 | Twist_Error > 10 | Twist_Error < -10 ) Allow_Loc_Error = 0.
EXECUTE.


*Set all MEPs to be included, but once computed do manual check here and set to 0 if noise in MEP window.

COMPUTE Allow_MEP = 1. 
EXECUTE.


*If any of the allow conditions are 0, then set ALLOW to 0 for filtering.

COMPUTE ALLOW = 1.
IF (Allow_MEP = 0 | Allow_Loc_Error = 0 | Allow_1st_Trial = 0) ALLOW = 0.
EXECUTE.

USE ALL. 
FILTER BY ALLOW. 
EXECUTE.

****************************************************RUN MEP MEANS HERE*******************************

MEANS TABLES=MEP_AUC BY Stimtype1AI2HI3H4DN 
  /CELLS=MEAN COUNT STDDEV.

COMPUTE MEAN_VAR = 0.
COMPUTE SD_VAR = 0. 

****************************
*BEGIN MANUAL INPUT

*INSERT MEP VALUES PER PARTICIPANT HERE

IF (Participant = 'SUBJECT_XYZ' & Stimtype1AI2HI3H4DN = 1) MEAN_VAR = 73.0013.
IF (Participant = 'SUBJECT_XYZ' & Stimtype1AI2HI3H4DN = 3) MEAN_VAR = 75.9034.
IF (Participant = 'SUBJECT_XYZ' & Stimtype1AI2HI3H4DN = 4) MEAN_VAR = 70.3778.
IF (Participant = 'SUBJECT_XYZ' & Stimtype1AI2HI3H4DN = 1) SD_VAR = 21.07005.
IF (Participant = 'SUBJECT_XYZ' & Stimtype1AI2HI3H4DN = 3) SD_VAR = 16.14919.
IF (Participant = 'SUBJECT_XYZ' & Stimtype1AI2HI3H4DN = 4) SD_VAR = 21.42500.
EXECUTE.

*Repeat per participant

*END OF MANUAL INPUT
***************************

* Compute Maxmimum and Minimum values per participant per 3SD metric

COMPUTE MIN_VAL= (MEAN_VAR-(SD_VAR*3)).
COMPUTE MAX_VAL = (MEAN_VAR+(SD_VAR*3)).
EXECUTE.


*Exclude MEP if MEP is larger than Max Value or smaller than Min Value allowed

IF ((MEP_AUC > MAX_VAL) | (MEP_AUC< MIN_VAL)) ALLOW = 0.
EXECUTE.


************************************************************************************************************

USE ALL. 
FILTER BY ALLOW. 
EXECUTE.

*Further descriptives are run in SPSS to determine if participant is filtered overall, resulting in CSV file.
