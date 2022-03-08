
% Postprocessing function, should be used after main_MEA_Axion
% Function: grouping of values along variables (groups/Treatments)
% (:SpikeCalculator:)
%
% Input: 
%       listOfGroups, is calculated by xlsx2mat_grouping (containing
%       groups and belonging wells); (variable names = group name, wells are listed row-wise)
% uiinput:
%       data struct returned by main_MEA_Analysis, stored in the folder
%       spikeCalculator
%
% output: 
%       data struct containing a cell array with grouped values for each
%       parameter returned by the Spike Calculator


function stat_burstCalculator = groupBurstCalc_GUI(names, sheetname,  nbGroups ,groupingFile, varargin)

listOfGroups = xlsx2mat_grouping_GUI(sheetname,  nbGroups ,names, groupingFile);

[fileName, pathName] = uigetfile('*.*','select data from burst Calculator','MultiSelect','on');

% get the cell array out of the data struct
nbM = length(fileName);
nbG = size(listOfGroups,2);
maxNbWell = size(listOfGroups,1)-1;

if ~iscell(fileName)
    fileName = cellstr(fileName);
end

 %preallocate datastruct stat_spikeCalculator
 stat_burstCalculator = repmat(struct('measurement_name',[]),1,nbM);
for m = 1:nbM
    dataStruct = load(fullfile(pathName,fileName{m}),'-mat');
    data = dataStruct.burstCalcResult.summary_of_Results;
    namWell = data(1,2:end);
    nbWell = length(namWell);
    
    %preallocate cells for data storage // one cell per parameter
    numberOfBursts = cell(maxNbWell+2, nbG);
    MBR = cell(maxNbWell+2, nbG); %mean burst rate
    wMBR = cell(maxNbWell+2, nbG);
    MBD = cell(maxNbWell+2, nbG); %mean burst duration
    SDBD = cell(maxNbWell+2, nbG); %standard deviation of burst duration
    avg_nbSpikesInBurst = cell(maxNbWell+2, nbG); 
    std_nbSpikesInBurst = cell(maxNbWell+2, nbG);
    
   
    for gr = 1:nbG
        grNam = listOfGroups{1,gr};
        wells = listOfGroups(2:end,gr);     
        
        
        %nbVal = length(wells);
        dataSub = data(2:end,2:end);
        log = zeros(nbWell,1);
        for k = 1:nbWell
            log(k) = sum(strcmp(namWell{k},wells)) >= 1;
        end
        log = logical(log);
        
        %number of bursts per well       
        numberOfBursts(1,1) = {'number of bursts per well'};
        numberOfBursts(2,gr) = {grNam};
        numberOfBursts(3:length(dataSub(1,log')')+2,gr) = dataSub(1,log')';
        
        %mean burst rate per well     
        MBR(1,1) = {'mean burst rate per well'};
        MBR(2,gr) = {grNam};
        MBR(3:length(dataSub(1,log')')+2,gr) = dataSub(2,log')';
        
        
        %weighted mean burst rate per well     
        wMBR(1,1) = {'weighted mean burst rate per well'};
        wMBR(2,gr) = {grNam};
        wMBR(3:length(dataSub(1,log')')+2,gr) = dataSub(3,log')';
        
        %mean burst duration per well
        MBD(1,1) = {'mean burst duration per well'};
        MBD(2,gr) = {grNam};
        MBD(3:length(dataSub(1,log')')+2,gr) = dataSub(4,log')';
        
        %standard deviation of burst duration per well
        SDBD(1,1) = {'standard deviation of burst duration per well'};
        SDBD(2,gr) = {grNam};
        SDBD(3:length(dataSub(1,log')')+2,gr) = dataSub(5,log')';
        
        %average number of spikes per burst
        avg_nbSpikesInBurst(1,1) = {'average number of spikes per burst'};
        avg_nbSpikesInBurst(2,gr) = {grNam};
        avg_nbSpikesInBurst(3:length(dataSub(1,log')')+2,gr) = dataSub(6,log')';
        
        %standard deviation of number of spikes per burst
        std_nbSpikesInBurst(1,1) = {'standard deviation of number of spikes per burst'};
        std_nbSpikesInBurst(2,gr) = {grNam};
        std_nbSpikesInBurst(3:length(dataSub(1,log')')+2,gr) = dataSub(6,log')';
        
        go2stat_burstCalculator.numberOfBursts = numberOfBursts;
        go2stat_burstCalculator.MBR = MBR;
        go2stat_burstCalculator.wMBR = wMBR;
        go2stat_burstCalculator.MBD = MBD;
        go2stat_burstCalculator.SDBD = SDBD;
        go2stat_burstCalculator.mean_nbSpikesBurst = avg_nbSpikesInBurst;
        go2stat_burstCalculator.std_nbSpikesBurst = std_nbSpikesInBurst;
        
    end
    stat_burstCalculator(m).measurement_name = strrep(fileName{m},'.mat','');
    stat_burstCalculator(m).data_for_statistic = go2stat_burstCalculator;
end
savename = fullfile(pathName,'BurstCalculator_Evaluation');
if ~exist (savename,'dir')
    mkdir(pathName,'BurstCalculator_Evaluation');
end
save (fullfile(savename,'burstCalc_grouped'), 'stat_burstCalculator');

end