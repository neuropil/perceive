function [] = ocd_dbs_group(trialN , hemisphere)

% 1st trial
% L before vs after

% Percent change

%%%%
% Inputs:
%%%
% trialN = 1 or 2
% hemisphere = 'L' or 'R'

% cd('D:\Dropbox\OCD_DBS_JSON')
% cd('D:\Dropbox\OCD_DBS_JSON\MP_CaseReport_2023')
cd('C:\Users\johna\Dropbox\OCD_DBS_JSON\MP_CaseReport_2023')


[jsonFnameTab] = getJSONofInt(trialN , hemisphere);


exposureID = cell(2,4); % file name and exposure ID (before or after) and matrix

for ji = 1:height(jsonFnameTab)

    tmpfname = jsonFnameTab.jsonFiles{ji};
    jsonfile = jsondecode(fileread(tmpfname));
    exposCheck = contains(tmpfname,'after');

    [procMat , tmpHzTRx , senseELall2] = getProcessMat(jsonfile);

    exposureID{ji,1} = tmpfname;

    if exposCheck
        exposureID{ji,2} = 'AFTER';
    else
        exposureID{ji,2} = 'BEFORE';
    end

    exposureID{ji , 3} = senseELall2;
    exposureID{ji , 4} = procMat;

end

exposureIDt = cell2table(exposureID,'VariableNames',{'Hemisphere','Condition','E_Pairs','LFPdata'});

exposureIDtn = normalDAT(exposureIDt);

% Compare each bipolar pair with percent change - plot one%
%diff = x2 - x1; % x2 and x1 are your input variables. x1 is reference and x2 the value to compare
%relDiff = diff / x1;

% Loop through electrodes
% Before is reference

beforeIND = matches(exposureIDtn.Condition,'BEFORE');
beforeEP = exposureIDtn.E_Pairs{beforeIND};
beforeLFP = exposureIDtn.LFPdata{beforeIND};
afterEP = exposureIDtn.E_Pairs{~beforeIND};
afterLFP = exposureIDtn.LFPdata{~beforeIND};


% Extract max peak uVp and Hz
% after
bandsti = [1 , 4, 8, 13, 31];
bandsto = [3 , 7, 12, 30 50];
maxuvp = [0, 0, 0, 0, 0];
maxfreq = [0, 0, 0, 0, 0];
for i = 1:6

    for bi = 1:length(bandsti)

        bandINDEX = tmpHzTRx >= bandsti(bi) & tmpHzTRx <= bandsto(bi);
        tmpROWb = afterLFP(bandINDEX);


        %         tmpROWb = afterLFP(i,bandsti(bi):bandsto(bi));
        tmpFREQ = tmpHzTRx(bandINDEX);
        [maxuvpT , maxLOC] = max(tmpROWb);

        if maxuvpT > maxuvp(bi)
            maxuvp(bi) = maxuvpT;
            maxfreq(bi) = tmpFREQ(maxLOC);

        end

    end
end



bandsti = [1 , 4, 8, 13, 31];
bandsto = [3 , 7, 12, 30 50];
maxuvp = [0, 0, 0, 0, 0];
maxfreq = [0, 0, 0, 0, 0];
for i = 1:6

    for bi = 1:length(bandsti)

        bandINDEX = tmpHzTRx >= bandsti(bi) & tmpHzTRx <= bandsto(bi);
        tmpROWb = beforeLFP(bandINDEX);


%         tmpROWb = afterLFP(i,bandsti(bi):bandsto(bi));
        tmpFREQ = tmpHzTRx(bandINDEX);
        [maxuvpT , maxLOC] = max(tmpROWb);

        if maxuvpT > maxuvp(bi)
            maxuvp(bi) = maxuvpT;
            maxfreq(bi) = tmpFREQ(maxLOC);

        end

    end
end





diffComps = zeros(6,72);

for fi = 1:6

    refLFPc = beforeEP{fi};
    comLFPcLoc = matches(afterEP,refLFPc);

    refLFPdata = beforeLFP(fi,:);
    comLFPdata = afterLFP(comLFPcLoc,:);

    subDIFF = comLFPdata - refLFPdata; % post - pre
    % subDIFF = refLFPdata - comLFPdata;

    diffComps(fi,:) = subDIFF;

end

titleUSE = [hemisphere , ' trial ' num2str(trialN)];

plotFUN(tmpHzTRx , diffComps , beforeEP , titleUSE , trialN)


% STATS
outTable = freqSTATS(tmpHzTRx , beforeLFP , afterLFP , beforeEP);



end





function [jsonFnameTab] = getJSONofInt(trialN , hemisphere)

flist = dir('*.json');
flistjson = {flist.name};

if trialN == 1
    triRows = flistjson(contains(flistjson , '1sttrial'));
else
    triRows = flistjson(contains(flistjson , '2ndtrial'));
end

if matches(hemisphere,'L')
    hemiRows = triRows(contains(triRows, 'Left'));
else
    hemiRows = triRows(contains(triRows, 'Right'));
end

% fileName , hemisphere, trialN
hemiRows2 = transpose(hemiRows);

jsonFnameTab = table(hemiRows2,repmat({num2str(trialN)},height(hemiRows2),1),...
    repmat({hemisphere},height(hemiRows2),1),...
    'VariableNames',{'jsonFiles','TrialN','HemiSide'});


end




function [procMat , tmpHzTRx , senseELall2] = getProcessMat(jsonfile)


tmpLFPbrainSense = jsonfile.LFPMontage;
tmpLFPtab = struct2table(tmpLFPbrainSense);


smothLFPtrim = zeros(6,72);
senseELall = cell(6,2);
for ti = 1:height(tmpLFPtab)

    senseEle = tmpLFPtab.SensingElectrodes{ti};
    senseEleName = extractAfter(senseEle,'.');
    [senseELnums] = translateNums(senseEleName);

    tmpLFP = tmpLFPtab.LFPMagnitude{ti};
    tmpHz = tmpLFPtab.LFPFrequency{ti};
    tmpHZcut = tmpHz < 70;

    tmpLFPsm = smoothdata(tmpLFP,'gaussian',7);
    tmpLFPtrim = tmpLFPsm(tmpHZcut);

    % plot(tmpHz(tmpHZcut),tmpLFPsm(tmpHZcut))
    smothLFPtrim(ti,:) = tmpLFPtrim;
    senseELall(ti,:) = senseELnums;

end

tmpHzTRx = tmpHz(tmpHZcut);

% Normalize
procMat = smothLFPtrim;
% unfurl = reshape(smothLFPtrim,numel(smothLFPtrim),1);
% normLFP = normalize(unfurl,'range');
% procMat = reshape(normLFP,6,72);
% plot(transpose(normSlfp))
% senseELallS = senseELall(high2low,:);
senseELall2 = join(senseELall,'-');

end



function [getNUms] = translateNums(eleName)

splitNames = split(eleName,'_');

getNUms = cell(1,2);
numCount = 1;
for si = 1:length(splitNames)

    if ~matches(splitNames{si},{'ZERO','ONE','TWO','THREE'})
        continue
    else
        switch splitNames{si}
            case 'ZERO'
                getNUms{numCount} = '0';
            case 'ONE'
                getNUms{numCount} = '1';
            case 'TWO'
                getNUms{numCount} = '2';
            case 'THREE'
                getNUms{numCount} = '3';
        end
        numCount = numCount + 1;
    end

end

end





function [outTABLE] = normalDAT(inTABLE)


allDATA = [inTABLE.LFPdata{1} ; inTABLE.LFPdata{2}];

unfurl = reshape(allDATA,numel(allDATA),1);
normLFP = normalize(unfurl,'range');
procMat = reshape(normLFP,12,72);

outTABLE = inTABLE;
outTABLE.LFPdata{1} = procMat(1:6,:);
outTABLE.LFPdata{2} = procMat(7:12,:);


end





function [] = plotFUN(freqXax , LFPin , legendLabs , titleUSE , trialNUM)

figure;
% Reorder to max peak
minShiftVs = min(LFPin,[],2);

minShift = zeros(size(LFPin));
for minV = 1:6
    minShift(minV,:) =  LFPin(minV,:) - minShiftVs(minV); 
end

averagePOWER = mean(minShift,2);
[~ , high2low] = sort(averagePOWER , 'descend');

normSlfp = LFPin(high2low,:);

coloRS = [191, 15, 255;...
          194, 75, 210;...
          197, 135, 164;...
          200, 195, 119;...
          202, 225, 96;...
          203, 255, 73];
coloRSrgb = coloRS/255;

lineAlphas = linspace(0.9,0.2,6);
lineWidths = linspace(2,0.5,6);

normSlfpLt = transpose(normSlfp);

for lfpi = 1:width(normSlfpLt)

    hold on
    lalph = lineAlphas(lfpi);
    plot(freqXax,normSlfpLt(:,lfpi),'Color',[coloRSrgb(lfpi,:) lalph],...
        'LineWidth',lineWidths(lfpi))

end
hold off

if trialNUM == 1
    ylim([-0.15 0.15])
    yticks([-0.15 0 0.15])
else
    ylim([-0.3 0.15])
    yticks([-0.3 -0.15 0 0.15])
end


xlim([0 60])
xticks([0 10 20 30 40 50 60])

ylabel('Normalized LFP magnitude POST - PRE')
xlabel('Frequency (Hz)')
legend(legendLabs(high2low))
title(titleUSE)


axis square


end






function [outTable] = freqSTATS(tmpHzTRx , beforeLFP , afterLFP , contactPairsBef)


freqS = [1 4;...
         4 8;...
         8 13;...
         13 30;...
         30 50];
allps = zeros(6*5,1);
allfreqs = cell(6*5,1);
contactP = cell(6*5,1);
countS = 1;
for ci = 1:6
    for fi = 1:height(freqS)

        beforeTlfp = beforeLFP(ci,tmpHzTRx > freqS(fi,1) & tmpHzTRx < freqS(fi, 2));
        afterTlfp = afterLFP(ci,tmpHzTRx > freqS(fi,1) & tmpHzTRx < freqS(fi, 2));


        [a,~,~] = ttest2(beforeTlfp , afterTlfp);

        if a
            allps(countS) = 1;
            contactP{countS} = contactPairsBef{ci};
            switch fi
                case 1
                    allfreqs{countS} = 'd';
                case 2
                    allfreqs{countS} = 't';
                case 3
                    allfreqs{countS} = 'a';
                case 4
                    allfreqs{countS} = 'b';
                case 5
                    allfreqs{countS} = 'g';
            end
            countS = countS + 1;
        end



    end

end

outTable = table(allps, allfreqs, contactP, 'VariableNames',{'Pvalues','Freqs','Contacts'});







end



