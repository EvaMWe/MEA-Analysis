% condition: > 0.1 Hz
spikeListExcl = getParticipater(spikeList, interval)

if iscell(spikeList)
    array = conversion(spikeList,1);
else
    array = spikeList;
end
nSpikeMax = size(spikeList,1) -1;

% calculate spike rate per electrode
emptyIndex = cellfun('isempty', spikeList);
numbSpikes = nSpikeMax - sum(emptyIndex,1);
spikeRate = numbSpikes./interval; %in HZ
excl = spikeRate <= 0.1;
spikeListExcl = spikeList;
spikeListExcl(:,excl) = [];
end

