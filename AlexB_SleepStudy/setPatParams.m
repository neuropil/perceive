function [] = createAlexSleepPatParams(saveDIR)

patParams = struct;

%% 1
patParams.P1.R.OverSat = true;
patParams.P1.R.json = 'Report_Json_Session_Report_20210521T115931[1].json';
%% 2
patParams.P2.L.OverSat = false;
patParams.P2.L.json = 'Report_Json_Session_Report_20210521T105436[1].json';
%% 3
patParams.P3.L.OverSat = true;
patParams.P3.L.json = 'Report_Json_Session_Report_20210514T110817.json';
%% 4
patParams.P4.R.OverSat = true;
patParams.P4.R.json = 'Report_Json_Session_Report_20210615T131452.json';
%% 5
patParams.P5.R.OverSat = true;
patParams.P5.R.json = 'Report_Json_Session_Report_20210707T111453.json';
%% 6
patParams.P6.R.OverSat = true;
patParams.P6.R.json = 'Report_Json_Session_Report_20210816T120043.json';
%% 7
patParams.P7.L.OverSat = true;
patParams.P7.L.json = 'Report_Json_Session_Report_20210726T094956.json';
patParams.P7.R.OverSat = true;
patParams.P7.R.json = 'Report_Json_Session_Report_20210726T100116.json';

dateCreate = datestr(now);

cd(saveDir)
save('PatParms.mat','patParams','dateCreate');





