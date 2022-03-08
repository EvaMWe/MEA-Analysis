function [interval,start,stop] = getInterval(spikeVec)

if size(spikeVec,2) > 1
   spikeVec = conversion(spikeVec, 2);
end

start = min(spikeVec);
stop = max(spikeVec);
interval = stop -start; %in seconds

end