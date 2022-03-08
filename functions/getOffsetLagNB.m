% this is a funtion to calculate a parameter I call offsetSpikeTime: t
% It's the time lag within a network burst from spike to spike, BUT
% consecutive spikes on the same electrode are excluded 

function lagTime = getOffsetLagNB(TS)

TSdiff = diff(TS);                          %get starts and stops of signals
sp = any((TSdiff == 1),2);                  %logical vector indicating starts
nSp = sum(TS,2);
ind = find(sp == 1);

all1 = sum(TS(:));
rc = [r c];
startArray = zeros(all1,16);
for x = 1:16
 channel = r(rc(:,2)==x);
 startArray(1:length(channel),x) = channel;
end
