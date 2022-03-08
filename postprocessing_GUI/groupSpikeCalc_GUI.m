% Postprocessing function, should be used after main_MEA_Axion
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


function stat_spikeCalculator = groupSpikeCalc_GUI(names, sheetname, nbGroups, groupingFile,varargin)

%cd (savepath)

listOfGroups = xlsx2mat_grouping_GUI( sheetname,  nbGroups ,names, groupingFile);

[fileName, pathName] = uigetfile('*.*','select data from spike Calculator','MultiSelect','on');

%get the cell array out of the data struct
nbM = length(fileName);
nbG = size(listOfGroups,2);
maxNbWell = size(listOfGroups,1)-1;

if ~iscell(fileName)
    fileName = cellstr(fileName);
end

%preallocate datastruct stat_spikeCalculator
stat_spikeCalculator = repmat(struct('measurement_name',[]),1,nbM);
for m = 1:nbM
    dataStruct = load(fullfile(pathName,fileName{m}),'-mat');
    data = dataStruct.resultsSpkCalc.summary_perWell;
    namWell = data(1,2:end);
    nbWell = length(namWell);
    
    %preallocate cells for data storage // one cell per parameter
    numbSpikes = cell(maxNbWell+2, nbG);
    nbContrCh = cell(maxNbWell+2, nbG);
    MFR = cell(maxNbWell+2, nbG);
    wMFR = cell(maxNbWell+2, nbG);
    w2tMFR = cell(maxNbWell+2, nbG);
    ISIavg = cell(maxNbWell+2, nbG);
    ISIstd = cell(maxNbWell+2, nbG);
    
    
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
        
        %number of spikes per well
        numbSpikes(1,1) = {'number of Spikes per well'};
        numbSpikes(2,gr) = {grNam};
        numbSpikes(3:length(dataSub(1,log')')+2,gr) = dataSub(1,log')';
        
        %number of contributing electrodes per well
        nbContrCh(1,1) = {'number of contributing electrodes per well'};
        nbContrCh(2,gr) = {grNam};
        nbContrCh(3:length(dataSub(1,log')')+2,gr) = dataSub(2,log')';
        
        
        %Mean firing rate per well
        MFR(1,1) = {'mean firing rate per well'};
        MFR(2,gr) = {grNam};
        MFR(3:length(dataSub(1,log')')+2,gr) = dataSub(3,log')';
        
        %weighted firing rate per well
        wMFR(1,1) = {'weighted mean firing rate per well'};
        wMFR(2,gr) = {grNam};
        wMFR(3:length(dataSub(1,log')')+2,gr) = dataSub(4,log')';
        
        %firing rate weighted to total electrode number per well
        w2tMFR(1,1) = {'mean firing weighted 2 total el. number per well'};
        w2tMFR(2,gr) = {grNam};
        w2tMFR(3:length(dataSub(1,log')')+2,gr) = dataSub(5,log')';
        
        %averaged inter spike interval per well
        ISIavg(1,1) = {'averaged inter spike interval per well'};
        ISIavg(2,gr) = {grNam};
        ISIavg(3:length(dataSub(1,log')')+2,gr) = dataSub(6,log')';
        
        %standard deviation of inter spike interval per well
        ISIstd(1,1) = {'averaged inter spike interval per well'};
        ISIstd(2,gr) = {grNam};
        ISIstd(3:length(dataSub(1,log')')+2,gr) = dataSub(6,log')';
        
        go2stat_spikeCalculator.numbSpikes = numbSpikes;
        go2stat_spikeCalculator.numbContrEl = nbContrCh;
        go2stat_spikeCalculator.MFR = MFR;
        go2stat_spikeCalculator.wMFR = wMFR;
        go2stat_spikeCalculator.w2tMFR = w2tMFR;
        go2stat_spikeCalculator.ISIavg = ISIavg;
        go2stat_spikeCalculator.ISIstd = ISIstd;
        
    end
    stat_spikeCalculator(m).measurement_name = strrep(fileName{m},'.mat','');
    stat_spikeCalculator(m).data_for_statistic = go2stat_spikeCalculator;
end
savename = fullfile(pathName,'SpikeCalculator_Evaluation');
if ~exist (savename,'dir')
    mkdir(pathName,'SpikeCalculator_Evaluation');
end
save (fullfile(savename,'spikeCalc_grouped'), 'stat_spikeCalculator');
end