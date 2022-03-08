%spikeList is a cell array or double array
% it's just possible to put in one well, otherwise out of memory! (after 21
% wells)

%returns a binary matrix indicating spikes at sample point
function TS = getTimeStamp(spikeList)

% check if data refers to one well
if size(spikeList,1) == 2 %this means this is the summary cell
    error('dimension mismatch, insert data of one well')
elseif size(spikeList,2) > 16 %more than one well contained, --> get wells
    error('dimension mismatch, insert data of one well')
else %just one well
    SLtemp = spikeList;
end

if iscell(SLtemp)
    SL = conversion(SLtemp,1);
else
    SL = SLtemp;
end

%ckeck if there is data:
sum(SL,2);

%create zero Matrix
[interval, offset] = getInterval(SL);

if isempty(interval) || isempty(offset)
    TS = 0;
    return
end

nbCh = size(SL,2);
nbSteps = round(12500*interval); %interval in seconds
maxRow = getMaxRow(nbCh);

if nbSteps>=maxRow
    nbSteps = maxRow;
end
TS = zeros(nbSteps,nbCh);

SLidx = round((SL-offset).*12500); %get the idx for each spike
SLidx(SLidx <= 0) = 0;

%read in TS

for el = 1:nbCh
    idx = SLidx(:,el);
    stop = find(idx==0, 1, 'first');
    idx = idx(1:stop-1);
    if idx > nbSteps
        continue
    end
    TS(idx,el) = 1;
end
end