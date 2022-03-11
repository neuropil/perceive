function [] = sleepPlotHelp_fun(mainLOC , caseID)
% C:\Users\johna\Dropbox\Publications_Meta\InProgress\ABaumgartner_Percept2020\SummaryMAT

cd(mainLOC)

matDir = dir('*.mat');
matDir2 = {matDir.name};

switch caseID
    case 'all'
         matDir2use = matDir2;
    otherwise

        % Find timeline mat files
        [~,fNames,~] = cellfun(@(x) fileparts(x), matDir2, 'UniformOutput', false);
        tlList = matDir2(contains(fNames,'TimeLine'));

        tlParts = split(tlList , '_');
        tlNum = replace(tlParts(:,:,1),'SPPD','');

        matDir2use = tlList(matches(tlNum,caseID));

end

for i = 1:length(matDir2use)

    load(matDir2use{i},'outMAT')
    fig = figure;
    left_color = [1 0 0];
    right_color = [0 0 0];
    set(fig,'defaultAxesColorOrder',[left_color; right_color]);


    nLFP = normalize(outMAT.LFP,'range');
    % Plot raw
    % plot(1:144,nLFP,'Color',[0.5 0.5 0.5])
    mLFP = mean(nLFP,2);
    sLFP = std(nLFP,[],2);
    uLFP = mLFP + sLFP;
    dLFP = mLFP - sLFP;
    daYS = size(nLFP,2);
    hold on
    % Plot mean


    yyaxis left
    plot(1:144,mean(nLFP,2),'Color','r','LineWidth',2)
    plot(1:144,uLFP,'Color',[1,0.5,0.5],'LineWidth',1,'LineStyle','--')
    plot(1:144,dLFP,'Color',[1,0.5,0.5],'LineWidth',1,'LineStyle','--')
    ylabel(['Normalized power - peak beta [', num2str(daYS) ,' Days]'])


    % Plot mean ACT
    nACT = normalize(outMAT.ActMean,'range');
    mACT = mean(nACT,2,'omitnan');
    yyaxis right
    plot(1:144,mACT,'Color','k','LineWidth',1,'LineStyle','-')

    ylabel(['Normalized Actigraphy [', num2str(daYS) ,' Days]'])

    xl1 = xline(90,'-.','9 PM','DisplayName','Average Sales');
    xl2 = xline(7,'-.','7 AM','DisplayName','Average Sales');
    xl1.LabelVerticalAlignment = 'top';
    xl1.LabelHorizontalAlignment = 'center';
    xl2.LabelVerticalAlignment = 'top';
    xl2.LabelHorizontalAlignment = 'center';

    xticks(1:144)
    xticks(ceil(linspace(1,144,12)))
    xticklabels(outMAT.TimeX(ceil(linspace(1,144,12))))
%     yticks([0 0.5 1])



end