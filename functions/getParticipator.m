% condition: > 0.1 Hz
% input: spikeList should is a double array or cell array containing the
%           spike stamps per each electrode within one well;
%           empty: logical vecotr indicating fields without spike
%           interval: duration of experiment
%output: numbPart: number of octributing electrodes
%        participators: double array containing data of contributung electrodes
%        excl: vector specifing non-contibuting electrodes
function [numbPart, participators, excl] = getParticipator(spikeList, empty,interval)

if iscell(spikeList)
    array = conversion(spikeList,1);
else
    array = spikeList;
end

%number of spikes per electrode
numbSpikes =repmat(length(empty),1,size(empty,2)) - sum(empty);

% calculate spike rate per electrode
spikeRate = numbSpikes./interval; %in HZ

excl = spikeRate <= 0.1;
participators = array;
participators(:,excl) = [];
numbPart = size(participators,2);
end

