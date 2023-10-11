% This is the ANALYSIS PACKAGE for MEA Data derived from MEASTRO AXION
%----02.01.2020
%----written by Eva-Maria Weiss
%
%
% update: here data bins are read in instead the whole excel file list
%        containing the spike data
% main parts are therefore similar to 'MeaCalc'
%
% 
% (1) Detection of valid electrodes
% - for data cleaning
% - read in baseline data; this is basic for the whole experiment (also for
%   following days, each measurement that is linked to one experiment is
%   treated according to this result
%
% (2) Inititaliziation
%     data bins are loaded, cleared for invalid electrodes and stored as a
%     data cell per bin with timepoints x electrodes
%     a data struct is generated containing name of bin, data and the list
%     of valid electrodes
%
% %  (3) Spike Detector Analysis
%   resultsSpkDet is a data struct containing following parameters
%     % 
%     % * number of spikes per electrode
%     % * number of electrodes
%     % * ISI average
%     % * ISI standard deviation
%     % * firing rate
%     % * summarizing cell array
%     % 
% (4) Spike Calculator
%       resultsSpkCalc is a data struct containing following parameters
    % 
    % * number of spikes per well
    % * number of participating electrodes per well
    % * Mean Firing Rate (MFR)
    % * weighted MFR (to valid)
    % * weighted MFR (to total)
    % * ISI_average
    % * ISI_standard deviation
    % * summarizing cell array
% (5) Burst Detector
 %      burst_detector contains a struct with following parameters:
    %  (1xnElectrode cell arrays, except the last field with the summary)
    %  * burst indices per electrode 
    %  * time points of bursts per electrode 
    %  * spike number per burst on each electrode 
    %  * mean spike number per electrode
    %  * standard deviation of spike number per electrode
    %  * number of bursts on each electrode
    %  * burst frequency
    %  * mean burst duration
    %  * standard deviation of burst duration
    %  * summary cell
    

    function savePath =MEA_IndividualParameters_forGUI(spikedetFlag, spikecalFlag, burstdetFlag, burstcalFlag, NB_ConFlag, z, S, contrEl)

%% set flags
%default
%spikedetFlag 
% spikecalFlag
% burstdetFlag 
% burstcalFlag 
% NB_ConFlag 



%% (0) get all files
% be sure to have the files names in an ascending direction
[baseInfo, basePath] = uigetfile('*.csv','select data',...
                                 'MultiSelect','on');
[savePath]= uigetdir('select folder to save data');




%% (1) Data cleaning
%receive spike list of first baseline bin
if ~iscell(baseInfo)
    baseInfo = cellstr(baseInfo);
end

nbBin = length(baseInfo);


firstList = getList('instruction','insert baseline files','multiSelection','off',...
                     'folder',basePath,'file',baseInfo{z}); %receive the spike list of baseline
dataRaw = firstList.data;
[~,validList, validWells] = cleanData(dataRaw, S, contrEl);

%% (2) Initializiation

dataStruct = repmat(struct('experiment',[]),1,nbBin);
dataStruct(1).validElectrods = validList;
dataStruct(1).validWells = validWells;
for bin = 1:nbBin
    %filename = strrep(baseInfo{bin},'.csv','');
    sprintf('%i',bin)
    spikeList = getList('nameList',validList,'folder',basePath,'file',baseInfo{bin});
    % get time interval
    spikeListArray = spikeList.data;
    
    spikeVec = conversion(spikeListArray, 2); %get list of all time stamps from each electrode together
    interval = getInterval(spikeVec); %in seconds
    
    
    dataStruct(bin).experiment = spikeList.experiment{1,1};
    dataStruct(bin).data = spikeList.data;
    dataStruct(bin).interval = interval;
end



    




%% (3) SPIKE DETECTOR analysis of individual electrodes 
if spikedetFlag == 1
    mkdir (savePath, 'spikeDetector');
    savepath_spikeDet = fullfile(savePath, 'spikeDetector');
    for bin = 1:nbBin
        data = dataStruct(bin).data;
        electrodeNames = dataStruct.validElectrods;
        %interval = dataStruct(bin).interval;
        [resultsSpkDet, interval] = spikeCalcIndiv(data, electrodeNames);
        spikeDetector.timePeriod = interval;
        spikeDetector.Spike_Detector = resultsSpkDet;
        filename = strrep(baseInfo{bin},'.csv','.mat');
        save(fullfile(savepath_spikeDet, filename),'spikeDetector');
    end
end
  
  
%% (4)SPIKE CALCULATOR analysis of each well
if spikecalFlag == 1
    mkdir (savePath, 'spikeCalculator');
    savepath_spikeCalc = fullfile(savePath, 'spikeCalculator');
    for bin = 1:nbBin
        data = dataStruct(bin).data;
        interval = dataStruct(bin).interval;
        
            [resultsSpkCalc,~,~] = spikeCalcWell(data,interval, dataStruct(1).validWells);
                    
        filename = strrep(baseInfo{bin},'.csv','.mat');
        save(fullfile(savepath_spikeCalc, filename),'resultsSpkCalc');
        clear spikeCalculator
    end
end
    
%% (5) BURST DETECTOR
if burstdetFlag == 1 || burstcalFlag == 1
    if burstdetFlag == 1
        mkdir (savePath, 'burstDetector');
        savepath_burstDet = fullfile(savePath, 'burstDetector');
    end
    for bin = 1:nbBin
        data = dataStruct(bin).data;
        %electrodeNames = dataStruct.validELectrods;
        interval = dataStruct(bin).interval;
        burstDetResult = burstDetector(data, interval);
        dataStruct(bin).burstDetData = burstDetResult;
        if burstdetFlag == 1
           filename = strrep(baseInfo{bin},'.csv','');
           save(fullfile(savepath_burstDet, filename),'burstDetResult');
        end
    end
end
   
    
%% (6) BURST CALCULATOR
% calculate parameters referring whole wells
if burstcalFlag == 1
    mkdir (savePath, 'burstCalculator');
    savepath_burstCalc = fullfile(savePath, 'burstCalculator');
    for bin = 1:nbBin
        burstDetResult = dataStruct(bin).burstDetData;
        interval = dataStruct(bin).interval;
        burstPerWell = getWells(burstDetResult.summary_of_Results, -1, dataStruct(1).validWells);
        burstCalcResult = burstCalculator_perWell(burstPerWell, interval);
        filename = strrep(baseInfo{bin},'.csv','');
        save(fullfile(savepath_burstCalc, filename),'burstCalcResult');
    end
end

%% (7) Net Work Burst and Connectivity (TIME stamp MATRIX needed)
% create time stamp matrix
% go well wise
if NB_ConFlag == 1
    mkdir(savePath, 'networkBursts');
    savepath_NB_burst = fullfile(savePath, 'networkBursts');
    mkdir(savePath, 'connectivity');
    savepath_connectivity = fullfile(savePath, 'connectivity');
    
    for bin = 1:nbBin
        spikeList = dataStruct(bin).data;
        interval = dataStruct(bin).interval;
        [wellList, ~] = getWells(spikeList, -1, dataStruct(1).validWells);
        nWell = size(wellList,2);
        networkBursts = repmat(struct('wellName',[]),nWell,1);
        connectivity = repmat(struct('wellName',[]),nWell,1);
        
        
        wellList1 = wellList;
        wellList2 = wellList;
        %Channge to parfor again
        for well = 1:nWell
            TS = getTimeStamp(wellList{2,well});
            % sprintf('%i',well)
            % results(bin).timeStemp(well) = TS;
            %sprintf('%i_%i',well,bin)
            NB = networkBurstCalc(TS, interval);  %per well
            %NB.wellName = wellList{1,well}{1,1};
            networkBursts(well).networkBurstsData = NB;
            networkBursts(well).wellName = wellList1{1,well}{1,1};
            
            %connectivity
            connectivity(well).wellName = wellList2{1,well}{1,1};
            
            [C,corr] = getConMat(TS); %time window surrounds spike
            spikeTimeTiling = STTC(TS);%based on getConMat
            
            connectivity(well).connectivityMatrix = C;
            connectivity(well).correlationMatrix = corr;
            connectivity(well).STTC = spikeTimeTiling;
            
            dataMat_upper= triu(spikeTimeTiling);
            dataMat_upper(dataMat_upper == 1) = 0;
            dataMat_upper(dataMat_upper == 0) = NaN;
            %dataMat_red = dataMat_upper(any(dataMat_upper,2),:);
            %dataMat_red2 = dataMat_red(:,any(dataMat_red,1));
            
            STTCvec = reshape(dataMat_upper',1,[]);
            STTCvec(isnan(STTCvec)) = [];
            meanSTTC = mean(STTCvec, 'omitnan');
            varSTTC = var(STTCvec, 'omitnan');
            skewSTTC = calcSkew(STTCvec);

            connectivity(well).meanSTTC = meanSTTC;
            connectivity(well).varSTTC = varSTTC;
            connectivity(well).skewSTTC = skewSTTC;
            
            %sprintf('well Nr %i',well)
        end

        filename = strrep(baseInfo{bin},'.csv','.mat');
        save(fullfile(savepath_NB_burst, filename),'networkBursts');
        save(fullfile(savepath_connectivity, filename), 'connectivity');
    end
end
end
