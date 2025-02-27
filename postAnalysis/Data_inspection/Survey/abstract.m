%here i will do the quick analysis of the variance
%using anova
%so a 3x3 array where the columns are the patients data
%the rows are the runs
%and the data inside is the whole power over the frequency region of
%interest


abstract_data = [];
%-------------------------------------------------------------------------
%left side patient 1 
cd('C:\Users\sydne\Documents\github\perceive\patientData\Patient1_0524')
jsonFiles = 'Report_Json_Session_Report_Patient1_right_init.json';
js = jsondecode(fileread(jsonFiles));
%sets it back to the path where all the other functions are
cd('C:\Users\sydne\Documents\github\perceive')
channels = unique({js.LfpMontageTimeDomain.Channel}, 'stable');
leng = numel({js.LfpMontageTimeDomain.Channel});
startindex = 7; %MUST BE MANUALLY SET IN CLINIC
colors = 'krbgmc';
maxValues = zeros(length(channels), 1);
for c=1:length(channels)
    maxValues(c) = tempAvgPlot(startindex, leng, js, channels{c}, colors(c));
    hold on;
end
[M, I] = max(maxValues);
highestBeta = channels{I};

patient = patientDataAbstract(startindex, js, leng, channels, 1, highestBeta); 
abstract_data = [abstract_data; patient];  

%-------------------------------------------------------------------------
%right side patient 1 
cd('C:\Users\sydne\Documents\github\perceive\patientData\Patient1_0524')
jsonFiles = 'Report_Json_Session_Report_20210524T101039.json';
js = jsondecode(fileread(jsonFiles));
%sets it back to the path where all the other functions are
cd('C:\Users\sydne\Documents\github\perceive')
channels = unique({js.LfpMontageTimeDomain.Channel}, 'stable');
leng = numel({js.LfpMontageTimeDomain.Channel});
startindex = 7; %MUST BE MANUALLY SET IN CLINIC
colors = 'krbgmc';
maxValues = zeros(length(channels), 1);
for c=1:length(channels)
    maxValues(c) = tempAvgPlot(startindex, leng, js, channels{c}, colors(c));
    hold on;
end
[M, I] = max(maxValues);
highestBeta = channels{I};

patient = patientDataAbstract(startindex, js, leng, channels, 1, highestBeta); 
abstract_data = [abstract_data; patient]; 

%-------------------------------------------------------------------------
%left side patient 2 
cd('C:\Users\sydne\Documents\MATLAB\ThompsonLab\Patient2_0604')
jsonFiles = 'Report_Json_Session_Report_20210604T094200.json';
cd('C:\Users\sydne\Documents\MATLAB\ThompsonLab')
js = jsondecode(fileread(jsonFiles));
channels = unique({js.LfpMontageTimeDomain.Channel}, 'stable');
leng = numel({js.LfpMontageTimeDomain.Channel});
sides = {'LEFT', 'RIGHT'};
startindex = 1;
channelsLeft = channels(contains(channels, sides{1}));
channelsRight = channels(contains(channels, sides{2}));
colors = 'krbgmc';
maxValues = zeros(length(channels), 1);
for c=1:length(channelsLeft)
    maxValues(c) = tempAvgPlot(startindex, leng, js, channelsLeft{c}, colors(c));
    hold on;
end
[M, I] = max(maxValues);
highestBeta = channelsLeft{I};

patient = patientDataAbstract(startindex, js, leng, channelsLeft, 2, highestBeta);
abstract_data = [abstract_data; patient]; 

%right side patient 2 
colors = 'krbgmc';
maxValues = zeros(length(channels), 1);
for c=1:length(channelsLeft)
    maxValues(c) = tempAvgPlot(startindex, leng, js, channelsRight{c}, colors(c));
    hold on;
end
[M, I] = max(maxValues);
highestBeta = channelsRight{I};

patient = patientDataAbstract(startindex, js, leng, channelsRight, 2, highestBeta);
abstract_data = [abstract_data; patient]; 

%--------------------------------------------------------------------------
%left side patient 3 
cd('C:\Users\sydne\Documents\github\perceive\patientData\Patient3_0630')
jsonFiles = 'Report_Json_Session_Report_20210630T155026.json';
js = jsondecode(fileread(jsonFiles));
%sets it back to the path where all the other functions are
cd('C:\Users\sydne\Documents\github\perceive')
%declares "global" variables AND determines if .json comes from
%single or double battery B)
channels = unique({js.LfpMontageTimeDomain.Channel}, 'stable');
leng = numel({js.LfpMontageTimeDomain.Channel});
startindex = 1; %MUST BE MANUALLY SET IN CLINIC
colors = 'krbgmc';
maxValues = zeros(length(channels), 1);
for c=1:length(channels)
    maxValues(c) = tempAvgPlot(startindex, leng, js, channels{c}, colors(c));
    hold on;
end
[M, I] = max(maxValues);
highestBeta = channels{I};

patient = patientDataAbstract(startindex, js, leng, channels, 3, highestBeta); 
abstract_data = [abstract_data; patient]; 

%-------------------------------------------------------------------------
%right side patient 3 
cd('C:\Users\sydne\Documents\github\perceive\patientData\Patient3_0630')
jsonFiles = 'Report_Json_Session_Report_20210630T143145.json';
js = jsondecode(fileread(jsonFiles));
%sets it back to the path where all the other functions are
cd('C:\Users\sydne\Documents\github\perceive')
%declares "global" variables AND determines if .json comes from
%single or double battery B)
channels = unique({js.LfpMontageTimeDomain.Channel}, 'stable');
leng = numel({js.LfpMontageTimeDomain.Channel});
startindex = 7; %MUST BE MANUALLY SET IN CLINIC
colors = 'krbgmc';
maxValues = zeros(length(channels), 1);
for c=1:length(channels)
    maxValues(c) = tempAvgPlot(startindex, leng, js, channels{c}, colors(c));
    hold on;
end
[M, I] = max(maxValues);
highestBeta = channels{I};

patient = patientDataAbstract(startindex, js, leng, channels, 3, highestBeta); 
abstract_data = [abstract_data; patient]; 

brainsense_stats = array2table(abstract_data, 'VariableNames', {'Power in Beta region', 'Run', 'Side', 'Patient'}); 
writetable(brainsense_stats, 'brainsense_stats.csv');  

anova1(brainsense_stats)
