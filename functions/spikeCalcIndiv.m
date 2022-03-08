function [results, interval] = spikeCalcIndiv(spikeList, nameElectrodes)

%% number of contributing electrodes
numbElectrodes = size(spikeList,2);
results.numbElectrodes = numbElectrodes;
nSpikeMax = size(spikeList,1) -1;

%% number of spikes per individual electrode

% how to convert  to array....
emptyIndex = cellfun('isempty', spikeList);
numbSpikes = nSpikeMax - sum(emptyIndex,1);
results.numbSpikesPerElectrode = numbSpikes;
%% ISI
spikeListArray = conversion(spikeList, 1);
ISIall = diff(spikeListArray,1,1);
ISIall(ISIall < 0) = 0;
ISIAverage = mean(ISIall,1);
ISIStd = std(ISIall,0,1);
results.ISIavg = ISIAverage;
results.ISIStd = ISIStd;

%% spike rate
% get time interval
spikeVec = conversion(spikeListArray, 2); %get list of all time stamps from each electrode together
interval = getInterval(spikeVec); %in seconds

% calculate spike rate per electrode
spikeRate = numbSpikes./interval; %in HZ
results.spikeRate = spikeRate;

excl = spikeRate <= 0.1;
spikeListRed = spikeList;
spikeListRed(:,excl) = [];

results.spikeListRed = spikeListRed;

sumIndivEl = cell(6,numbElectrodes+1);
sumIndivEl(1,2:end) = nameElectrodes;
nameVarRow = {'Name_Electrodes', 'numb_of_spikes', 'ISIavg in seconds', 'ISIstd','firing rate in Hz', 'numb_of_electrodes'};
sumIndivEl(:,1) = nameVarRow;
sumIndivEl(2,2:end) = num2cell(numbSpikes);
sumIndivEl(3,2:end) = num2cell(ISIAverage);
sumIndivEl(4,2:end) = num2cell(ISIStd);
sumIndivEl(5,2:end) = num2cell(spikeRate);
sumIndivEl(6,2) = num2cell(numbElectrodes);

results.sum = sumIndivEl;
end 