% Postprocessing function, should be used after main_MEA_Axion
% Function: grouping of values along variables (groups/Treatments)
% (:NBCalculator:)
%
% Input:
%       listOfGroups, is calculated by xlsx2mat_grouping (containing
%       groups and belonging wells); (variable names = group name, wells are listed row-wise)
% uiinput:
%       data struct returned by main_MEA_Analysis, stored in the folder
%       spikeCalculator
%
% SUBFUNCTION: rearrangeNB --> creates a cell array, with wells as
% variables (columns) and parameters listed rowwise

% output:
%       for each parameter a cell array is constructed; variable names are
%       the names of the groups, values are selected from several wells


function stat_ConnCalculator = groupConnCalc_GUI_(names, sheetname,  nbGroups, groupingFile, fileNames, pathName)

listOfGroups = xlsx2mat_grouping_GUI(sheetname,  nbGroups ,names, groupingFile);

nbG = size(listOfGroups,2);         %number of groups
maxNbWell = size(listOfGroups,1)-1; %maximum number of wells per group

if ~iscell(fileNames)
    fileNames = cellstr(fileNames);
end

nbM = length(fileNames);

stat_ConnCalculator = repmat(struct('measurement_name',[]),1,nbM);

for m = 1:nbM
    data = load(fullfile(pathName,fileNames{m}),'-mat');
    data = data.data; 
    
    %% rearrange data and return data cell
    data = rearrangeConn(data);
    %preallocate datastruct stat_spikeCalculator
    namWell = data(1,2:end);
    nbWell = length(namWell);
    
    %preallocate cells for data storage // one cell per parameter
    connectivityMatrix = cell(maxNbWell+2, nbG);
    correlationMatrix = cell(maxNbWell+2, nbG); %mean burst rate
    STTC = cell(maxNbWell+2, nbG);
    meanSTTC = cell(maxNbWell+2, nbG); %mean burst duration
    varSTTC = cell(maxNbWell+2, nbG); %standard deviation of burst duration
    skewSTTC = cell(maxNbWell+2, nbG);
    
    
    
    for gr = 1:nbG
        grNam = listOfGroups{1,gr};
        wells = listOfGroups(2:end,gr);       
        
        nbVal = length(wells);
        dataSub = data(2:end,2:end);
        log = zeros(nbWell,1);
        for k = 1:nbWell
            log(k) = sum(strcmp(namWell{k},wells)) >= 1;
        end
        log = logical(log);
        
        %connectivity Matrix
        connectivityMatrix(1,1) = {'connectivityMatrix'};
        connectivityMatrix(2,gr) = {grNam};
        connectivityMatrix(3:length(dataSub(1,log')')+2,gr) = dataSub(1,log')';
        
        %correlation Matrix
        correlationMatrix(1,1) = {'correlation Matrix'};
        correlationMatrix(2,gr) = {grNam};
        correlationMatrix(3:length(dataSub(2,log')')+2,gr) = dataSub(2,log')';
        
        
        %spike time tiling coefficient
        STTC(1,1) = {'spike time tiling coefficient'};
        STTC(2,gr) = {grNam};
        STTC(3:length(dataSub(3,log')')+2,gr) = dataSub(3,log')';
        
        %mean STTC
        meanSTTC(1,1) = {'mean STTC'};
        meanSTTC(2,gr) = {grNam};
        meanSTTC(3:length(dataSub(4,log')')+2,gr) = dataSub(4,log')';
        
        %variance in STTC
        varSTTC(1,1) = {'variance in STTC'};
        varSTTC(2,gr) = {grNam};
        varSTTC(3:length(dataSub(5,log')')+2,gr) = dataSub(5,log')';
        
        %skewness in STTC
        skewSTTC(1,1) = {'skewness in STTC'};
        skewSTTC(2,gr) = {grNam};
        skewSTTC(3:length(dataSub(6,log')')+2,gr) = dataSub(6,log')';
        
               
        go2stat_NBCalculator.connectivityMatrix = connectivityMatrix;
        go2stat_NBCalculator.correlationMatrix = correlationMatrix;
        go2stat_NBCalculator.STTC = STTC;
        go2stat_NBCalculator.meanSTTC = meanSTTC; 
        go2stat_NBCalculator.varSTTC = varSTTC; 
        go2stat_NBCalculator.skewSTTC = skewSTTC;
              
        stat_ConnCalculator(m).measurement_name = strrep(fileNames{m},'.mat','');
        stat_ConnCalculator(m).data_for_statistic = go2stat_NBCalculator;
    end
    %
    savename = fullfile(pathName,'Connectivity');
    if ~exist (savename,'dir')
        mkdir(pathName,'Connectivity');
    end
    save (fullfile(savename,'connectivity_grouped'), 'stat_ConnCalculator');
end
end


function [resultCell] = rearrangeConn(data)
nbWells = length(data);
resultCell = cell(1+6,1+nbWells);
resultCell(1,1) = {'name of well'};
resultCell(2,1) = {'connectivity Matrix'};
resultCell(3,1) = {'correlation Matrix'}; %mean duration of NB
resultCell(4,1) = {'spike time tiling coeff'};
resultCell(5,1) = {'meanSFFC'};
resultCell(6,1) = {'varSFFC'};
resultCell(7,1) = {'skewSFFC'};


for well = 1:nbWells
    wellName = data(well).wellName;
    resultCell(1,1+well) = {wellName};
    %resultCell(2,1+well) = {data(well).networkBurstsData.number_of_NB};
    resultCell(2,1+well) = {data(well).connectivityMatrix};
    resultCell(3,1+well) = {data(well).correlationMatrix};
    resultCell(4,1+well) = {data(well).STTC};
    resultCell(5,1+well) = {data(well).meanSTTC};
    resultCell(6,1+well) = {data(well).varSTTC};
    resultCell(7,1+well) = {data(well).skewSTTC};
end
end