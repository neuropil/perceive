%% Order of Scripts and Functions 
% -----Revise date - 3/8/2022
% Note: created


%% Step 1
% Process actigraphy
actigraphyProcess(subID)

%% Step 2
% One case

pat2use = 2;


mainDIR = 'D:\Dropbox\Publications_Meta\InProgress\ABaumgartner_Percept2020';
userDIRs = [mainDIR,'\Data\SPPD'];
userDIRe = '\JSON_LFP';
% saveDIRs = [mainDIR,'\Data\SPPD'];
saveDIRe = 'D:\Dropbox\Publications_Meta\InProgress\ABaumgartner_Percept2020\testSav';
tabLOC = [mainDIR,'\summarydataTab.csv'];
actDloc = [mainDIR,'\Data\SPPD'];


patParmsFs = fieldnames(patParms);
patFields = patParms.(patParmsFs{contains(patParmsFs,num2str(pat2use))});

hemiS = patFields.hemi;
patID = patFields.ID;
overSAT = patFields.OverSat;
jsonNAMEs = patFields.json;

saveDIR = saveDIRe;
userDIR = [userDIRs , num2str(patID) , userDIRe];
jsoN = jsonNAMEs;

perceive_sleepTandE_v6('overSAT',overSAT,'subID',patID,...
    'saveDIR',saveDIR,'stagE',1,'userDIR',userDIR,...
    "actDIR",actDloc,'hemiS',hemiS,"tabLOC",tabLOC,"jsonDAT",jsoN)