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


function stat_NBCalculator = groupNBCalc_GUI(names, sheetname,  nbGroups, groupingFile)

listOfGroups = xlsx2mat_grouping_GUI(sheetname,  nbGroups ,names, groupingFile);

[fileNames, pathName] = uigetfile('*.*','select data from folder networkBurst','MultiSelect','on');

%get the cell array out of the data struct
nbM = length(fileNames);
nbG = size(listOfGroups,2);         %number of groups
maxNbWell = size(listOfGroups,1)-1; %maximum number of wells per group


if ~iscell(fileNames)
    fileNames = cellstr(fileNames);
end


stat_NBCalculator = repmat(struct('measurement_name',[]),1,nbM);

for m = 1:nbM
    data = load(fullfile(pathName,fileNames{m}),'-mat');
    data = data.networkBursts;
    
    %% rearrange data and return data cell
    data = rearrangeNB(data);
    %preallocate datastruct stat_spikeCalculator
    namWell = data(1,2:end);
    nbWell = length(namWell);
    
    %preallocate cells for data storage // one cell per parameter
    nbNB = cell(maxNbWell+2, nbG);
    rateNB = cell(maxNbWell+2, nbG);
    avg_DNB = cell(maxNbWell+2, nbG); %mean burst rate
    std_DNB = cell(maxNbWell+2, nbG);
    avg_nbSp = cell(maxNbWell+2, nbG); %mean burst duration
    std_nbSp = cell(maxNbWell+2, nbG); %standard deviation of burst duration
    avg_nbCh = cell(maxNbWell+2, nbG);
    std_nbCh = cell(maxNbWell+2, nbG);
    
    
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
        
        %number of NB per well
        nbNB(1,1) = {'number of NB per well'};
        nbNB(2,gr) = {grNam};
        nbNB(3:length(dataSub(1,log')')+2,gr) = dataSub(1,log')';
        
         %NBrate per well
        nbNB(1,1) = {'NB rate'};
        nbNB(2,gr) = {grNam};
        nbNB(3:length(dataSub(1,log')')+2,gr) = dataSub(2,log')';
        
        %mean network burst duration per well
        avg_DNB(1,1) = {'mean network burst duration per well'};
        avg_DNB(2,gr) = {grNam};
        avg_DNB(3:length(dataSub(1,log')')+2,gr) = dataSub(3,log')';
        
        
        %standard deviation of network burst duration
        std_DNB(1,1) = {'standard deviation of network burst duration'};
        std_DNB(2,gr) = {grNam};
        std_DNB(3:length(dataSub(1,log')')+2,gr) = dataSub(4,log')';
        
        %average number of Spikes per NB in a well
        avg_nbSp(1,1) = {'average number of Spikes per NB in a well'};
        avg_nbSp(2,gr) = {grNam};
        avg_nbSp(3:length(dataSub(1,log')')+2,gr) = dataSub(5,log')';
        
        %standard deviation of Spikes per NB in a well
        std_nbSp(1,1) = {'standard deviation of Spikes per NB in a well'};
        std_nbSp(2,gr) = {grNam};
        std_nbSp(3:length(dataSub(1,log')')+2,gr) = dataSub(6,log')';
        
        %average number of contributing electrodes per well
        avg_nbCh(1,1) = {'average number of contributing electrodes per well'};
        avg_nbCh(2,gr) = {grNam};
        avg_nbCh(3:length(dataSub(1,log')')+2,gr) = dataSub(7,log')';
        
        %standard deviation of contributing electrodes per well
        std_nbCh(1,1) = {'standard deviation of contributing electrodes per well'};
        std_nbCh(2,gr) = {grNam};
        std_nbCh(3:length(dataSub(1,log')')+2,gr) = dataSub(8,log')';
        
        go2stat_NBCalculator.numberOfNB = nbNB;
        go2stat_NBCalculator.avg_DNB = avg_DNB;
        go2stat_NBCalculator.std_DNB = std_DNB;
        go2stat_NBCalculator.avg_nbSp = avg_nbSp;
        go2stat_NBCalculator.std_nbSp = std_nbSp;
        go2stat_NBCalculator.avg_nbCht = avg_nbCh;
        go2stat_NBCalculator.std_nbCh = std_nbCh;
        
        
    end
    stat_NBCalculator(m).measurement_name = strrep(fileNames{m},'.mat','');
    stat_NBCalculator(m).data_for_statistic = go2stat_NBCalculator;
end
savename = fullfile(pathName,'NBCalculator_Evaluation');
if ~exist (savename,'dir')
    mkdir(pathName,'NBCalculator_Evaluation');
end
save (fullfile(savename,'NBCalc_grouped'), 'stat_NBCalculator');
end



function [resultCell] = rearrangeNB(data)
nbWells = length(data);
resultCell = cell(1+8,1+nbWells);
resultCell(1,1) = {'name of well'};
resultCell(2,1) = {'number of network bursts'};
resultCell(3,1) = {'network burst rate'};
resultCell(4,1) = {'avg_DNB'}; %mean duration of NB
resultCell(5,1) = {'std_DNB'};
resultCell(6,1) = {'avg_number of spikes'};
resultCell(7,1) = {'std_number of spikes'};
resultCell(8,1) = {'avg_ number of contributing electrodes'};
resultCell(9,1) = {'std_number of contributing electrodes'};

for well = 1:nbWells
    wellName = data(well).wellName;
    resultCell(1,1+well) = {wellName};
    resultCell(2,1+well) = {data(well).networkBurstsData.number_of_NB};
    resultCell(3,1+well) = {data(well).networkBurstsData.NBrate};
    resultCell(4,1+well) = {data(well).networkBurstsData.average_duration_of_NB};
    resultCell(5,1+well) = {data(well).networkBurstsData.standardDeviation_duration_of_NB};
    resultCell(6,1+well) = {data(well).networkBurstsData.average_number_of_spikes};
    resultCell(7,1+well) = {data(well).networkBurstsData.stdNumbSpikes};
    resultCell(8,1+well) = {data(well).networkBurstsData.average_nb_of_contr_channele};
    resultCell(9,1+well) = {data(well).networkBurstsData.standardDeviation_of_contr_channels};
end
end