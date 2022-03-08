% input spikeList is a struct with the data in the 2. column
%input is an array with  pike data derived by baseline 20-30
% Here just one data set is valid since elimination of electrodes relies on
% the baseline on day 0 from minute 20 to 30;


function [spikeListExcl, spikeName, wellNames] = cleanData(data, varargin)
%% default, calculate spike rate to form condition (> 0.1 Hz)
S = 0.1;

if nargin == 2
    S = varargin{1};
end
[spikeListArray, empty] = conversion(data, 1); %convert cell to double, get list of empty fields

% get precise recording interval:
interval = getInterval(spikeListArray); %in seconds
numbSpikes = getSpikeNum(spikeListArray, empty);
spikeRate = numbSpikes./interval; %in HZ

excl = spikeRate <= S;
spikeListExcl = data;
spikeListExcl(:,excl) = [];
spikeName = spikeListExcl(1,:);

[~,wellNames] = getWells(spikeListExcl, 10);

end