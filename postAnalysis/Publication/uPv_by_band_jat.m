close all

cd('C:\Users\Admin\Documents\Github\perceive\MDT_phase1\patientData')
dir = readtable("PtDirectorySimple.xlsx");

mastertable = [];
mastertableJ = [];
%table with each run, contact, hemi and pt
for i = 1:height(dir)
    jsonFiles = dir.JsonSurvey{i};
    side = dir.Hemisphere{i};
    startIndex = dir.StartIndex(i);
    num = num2str(dir.Patient(i));
    hemi = upper(dir.Hemisphere(i));
    js = jsondecode(fileread(jsonFiles));
    outTABLE = extractSurveyData(js, side, startIndex);
    outTABLE2 = extractSurveyData_maxB(js, side, startIndex);
    pt = repmat({append("pt", num)}, 18, 1);
    outTABLE2.patient = pt;
    mastertable = [mastertable; outTABLE];
    mastertableJ = [mastertableJ ; outTABLE2];
end

localtab = [];  
y = zeros(4096,3); 
mastertable2 = mastertable;
col = []; 
%get only power data from mastertable
for x = 1:height(mastertable2) 
    temp = mastertable.PF_Data{x}; 
    col = [col; temp.Power]; 
end
%normalize and repack
normcol = normalize(col, 'range'); %pack into 0 to 1 
colm = reshape(col, 4096, height(mastertable2)); 

%put the normalized data into mastertable2 
for x = 1:height(mastertable)
    mastertable2.PF_Data{x}.Power = colm(:,x);
end

for k = 1:height(mastertable)
    %if we have the first run then we have that contact 
    if mastertable.RunNum(k) == 1 
        t = mastertable(k:k+2, :); %get all three runs for that contact
        for j = 1:3
            powerdata = t.PF_Data{j};
            y(:,j) = powerdata.Power; 
            runav = mean(powerdata.Power);%single av for all power data
            runavmat(j) = runav; %store in matrix 
        end
        ny1 = y(:); %takes y and makes it a column vector 
        %ny2 = normalize(ny1, 'range'); %makes it 0 to 1 
        ny3 = reshape(ny1, size(y)); %takes normalized data and reshapes to y 
        ny3 = mean(ny3,2); 
        runavall = mean(ny3); %average the average of all three runs, single number
        runst = std(ny3); %std dev of all three runs 
        new = mastertable(k, :); 
        new.PF_Data = []; 
        new.RunNum = []; 
        new.RunAvg = runavall; 
        new.RunStd = runst; 
        %new.avpwrdata = array2table(y); 
        localtab = [localtab; new];
        
    end
end