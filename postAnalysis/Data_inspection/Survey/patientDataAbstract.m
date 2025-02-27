function [patient_summary] = patientDataAbstract(startindex, js, leng, channels, patient_num, highestBeta)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%gives column a 1 for left and a 2 for right 
if contains(channels, 'LEFT')
    side = 1;
else
    side = 2;
end

patient_summary = [];
run = 0;
local_data = zeros(860, 4);
for i = startindex:leng
    if strcmp(js.LfpMontageTimeDomain(i).Channel,highestBeta)
        run = run+1;
        t = js.LfpMontageTimeDomain(i).TimeDomainData;
        [p,f] = pspectrum(t, 250, 'FrequencyLimits', [0 100]); %250 comes from json file itself
        fbeta = f > 12 & f < 33; %logical to only find beta region
        power_beta = p(fbeta);
        local_data(:,1) = power_beta;
        local_data(:,2) = run;
        local_data(:,3) = side;
        local_data(:,4) = patient_num; 
        patient_summary = [patient_summary; local_data];
    end
end
end 

