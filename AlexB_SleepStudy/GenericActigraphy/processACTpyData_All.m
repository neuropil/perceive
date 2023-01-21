function [] = processACTpyData_All(mainLOC, saveLOC)

% Create new Table with old ACT data and new ACT py processing
% Sleep/Wake periods
% Fits
% Separate table for Cosinar data

% Example for mainLOC =
% 'D:\Dropbox\Publications_Meta\InProgress\ABaumgartner_Percept2020\'

% Example of raw loc location
% 'D:\Dropbox\Publications_Meta\InProgress\ABaumgartner_Percept2020\Data\SPPD1\ACT_data\Summary'

% Location of all new Py data
% D:\Dropbox\Publications_Meta\InProgress\ABaumgartner_Percept2020\ActPyOUT
% Data type 1 - ACT = sleep/wake
% Data type 2 - actFit = fits
% Data type 3 - cosinar params

% Get list of subjects
cd([mainLOC , 'Data', filesep])

fDir1 = dir();
fDir2 = {fDir1.name};
fDir3 = fDir2(~ismember(fDir2,{'.','..'}));

for fi = 1:length(fDir3)

    % Load Raw table
    tmpSub = fDir3{fi};
    tmpACTrLoc = [mainLOC, 'Data' , filesep , tmpSub, filesep , 'ACT_data\Summary\'];
    cd(tmpACTrLoc)
    loadNAME = [tmpSub , '_ACT_DATA.mat'];
    load(loadNAME,'dataTable')
    
    % Load 3 new data types
    cd([mainLOC , 'ActPyOut' , filesep])
    % Get names from folder
    csvF = dir('*.csv');
    csvF1 = {csvF.name};
    spCSV = split(csvF1,'_');
    jspCSV = join([transpose(spCSV(:,:,1)),transpose(spCSV(:,:,2))],'');
    tmpFiles = csvF1(matches(jspCSV,tmpSub));
    tmpspCSV = split(tmpFiles,'_');
    tmpExts = tmpspCSV(:,:,3);
    % Sort and load files
    for ti = 1:3
        switch tmpExts{ti}
            case 'ACT.csv' % sleep wake
                actSleepW = readtable(tmpFiles{ti});
            case 'actFit.csv' % Fit data
                actFitdat = readtable(tmpFiles{ti});
            case 'CosinrParms.csv' % Cos Parms
                actCosP = readtable(tmpFiles{ti});
        end
    end

    % Combine
    sleepWakeFit = [actFitdat , actSleepW(:,2:end)];
    % Check height match 1
    if height(sleepWakeFit) == height(dataTable)
        trimACtraw = dataTable;
    else % Find end of block
        trimACtraw = findDay(sleepWakeFit , dataTable);
    end

    rawActSlWk = [trimACtraw , sleepWakeFit];
    cd(saveLOC)
 
    saveName = [tmpSub , '_ActALL.mat'];
    save(saveName , "rawActSlWk","actCosP");


end


end







function [outData] = findDay(stTimes , allData)

allMonth = month(datetime(join([allData.Date allData.Time],' ')));
allDay = day(datetime(join([allData.Date allData.Time],' ')));
allHour = hour(datetime(join([allData.Date allData.Time],' ')));
allMin = minute(datetime(join([allData.Date allData.Time],' ')));
allSec = second(datetime(join([allData.Date allData.Time],' ')));

allInds = zeros(1,2);
for i = 1:2
    switch i
        case 1 % start
            useTime = stTimes.Date_Time(1);
        case 2 % end
            useTime = stTimes.Date_Time(end);
    end
    useDay = day(useTime);
    useMon = month(useTime);
    useHour = hour(useTime);
    useMin = minute(useTime);
    useSec = second(useTime);

    dayFind = allDay == useDay &...
        allMonth == useMon &...
        allHour == useHour &...
        allMin == useMin &...
        allSec == useSec;
    allInds(i) = find(dayFind);
end

outData = allData(allInds(1):allInds(2),:);

end



