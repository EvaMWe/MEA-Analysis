%%
% input: spike data derived from one experiment as cell array; first row contains name of each electrod; optional: interval
%returns a cell array containing spike data in fields as cell array
%(1)get interval indicating the exact duration of an experiment


function [results,numWell,wellList] = spikeCalcWell(spikeData,varargin)


%% (1) get interval either from input arguments or by calcualation with getInterval
if isstruct(spikeData)
    interval = spikeData.interval;
    spikeList = spikeData.data;
else
    spikeList = spikeData;    
end

if nargin >= 2
    interval = varargin{1};    
end

if nargin == 3
    wellNames = varargin{2};
end


%% (2) group individual electrodes to wells
if exist('wellNames','var')
   [wellList, wellNames] = getWells(spikeList,-1, wellNames);
else
   [wellList, wellNames] = getWells(spikeList);
end
%wellNames = wellList(1,:);
   numWell = size(wellNames,2);

%% constructs for data storage
numberSpikes = zeros(1,numWell);
numbPartEl = zeros(1,numWell);
MFR = zeros(1,numWell);
CoV_MFR = zeros(1,numWell);
wMFR = zeros(1,numWell);
w2absMFR = zeros(1,numWell);
ISI_avg = zeros(1,numWell);
ISI_std = zeros(1,numWell);

sum_Well = cell(9, numWell+1);
variableNames = {'Name of Electrode';'Number of Spikes per well'; 'number of contributing electrodes per well';...
    'Mean Firing Rate'; 'Cov MFR';'Weighted Mean Firing Rate';'Weigthed to Absolute ElectrodeNumber';...
    'Inter Spike Interval (avg)';'Inter Spike Interval (std)'};
sum_Well(:,1) = variableNames;
sum_Well(1,2:end) = wellNames;

%% calculations per well...start loop
numWell = length(wellList);
for well = 1:numWell
    %get the data array from the summarizing cell array
    nums = wellList{2,well};
    [nums, empty] = conversion(nums,1);
    numsVec = conversion(nums,2);
    
    %%calculate MFR on individual electrodes for statistc measures:
    MFRel = arrayfun(@(i) nnz(nums(:,i)),1:size(nums,2))./interval;
    CoV_MFR_ = std(MFRel)/mean(MFRel);
    CoV_MFR(1,well) = CoV_MFR_;
    %% calculate the whole number of spike across the well
    nSpikes = length(numsVec);
    numberSpikes(1,well) = nSpikes;
    
    
    %% number of participating electrodes
    numbEl = size(nums,2);
    nPart = getParticipator(nums,empty,interval);
    numbPartEl(1,well) = nPart;
    
       
    
    % use these parameters for determine weigth
    %% spike rate // 'mean_firing_rate'; 'weighted_mean_firing_rate';'weighted2absoluteMFR'
    % overall
    spikeRate = nSpikes/interval;
    if nPart == 0
       MFR(1,well) = spikeRate;
       wMFR(1,well) = 0;
       w2absMFR(1,well) = 0;
       ISI_avg(1,well) = 0;
    %sprintf('wellNr.:%i',well)
       ISI_std(1,well) = 0;
       continue
    end
       
       
    MFR(1,well) = spikeRate;   
    wMFR(1,well) = (numbEl/nPart)*spikeRate;
    w2absMFR(1,well) = (16/nPart)*spikeRate;
        
    %% ISI // 'ISI_avg';'ISI_std'
    ISI = diff(numsVec);
    ISIavg = mean(ISI,2);
    ISIstd = std(ISI,0,2);
    
   
    if  isempty(ISIavg)||isnan(ISIavg) 
        ISI_avg(1,well) = 0;
    else
        ISI_avg(1,well) = ISIavg;
    end
    
    if isempty(ISIstd)||isnan(ISIstd)  
        ISI_std(1,well) = 0;
    else
        ISI_std(1,well) = ISIstd;
    end
        
end

%% construct data container
%create summarizing cell:
sum_Well(2,2:end) = num2cell(numberSpikes);
sum_Well(3,2:end) = num2cell(numbPartEl);
sum_Well(4,2:end) = num2cell(MFR);
sum_Well(5,2:end) = num2cell(CoV_MFR);
sum_Well(6,2:end) = num2cell(wMFR);
sum_Well(7,2:end) = num2cell(w2absMFR);
sum_Well(8,2:end) = num2cell(ISI_avg);
sum_Well(9,2:end) = num2cell(ISI_std);

%put all data into a data struct for storage:
results.numberSpikes = numberSpikes;
results.numbPartEl = numbPartEl;
results.MeanFiringRate = MFR;
results.CoV_MFR = CoV_MFR;
results.weightedMeanFiringRate = wMFR;
results.weighted2totalNumbElMFR = w2absMFR;
results.ISI_avg = ISI_avg;
results.ISI_std = ISI_std;
results.summary_perWell = sum_Well;

end
