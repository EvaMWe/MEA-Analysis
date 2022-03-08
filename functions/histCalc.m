% calculate histogram from a spikeList
%curWel is an array, channels in col, spikes in row; could be cell array or
%double
%varargin: 1= display 'on' figures are shown

function [nISI, logEdges, logBins, ISImean,ISIvec] = histCalc(curWel,varargin)
    
if iscell(curWel)
    [spikeList] = conversion(curWel, 1);
else
    spikeList = curWel;
end

if nargin == 2
    display = varargin{1};
end
ISIarray = zeros(size(spikeList));
ISImean = zeros(1,size(spikeList,2));

nEl = size(spikeList,2);

%% get ISI from each electrode and merge together
for el = 1:nEl
    ISI = diff(spikeList(:,el));
    ISI(ISI <= 0) =[];
    ISIarray(1:length(ISI),el) = ISI;
    ISImean(1,el) = mean(ISI).*12000;
end
%ISIarray(~any(ISIarray,2)) = [];
ISIvec = conversion(ISIarray,2);
ISIvec(ISIvec==0) = [];
ISIvec = ISIvec.*12000; %in sample-bins


%% mean ISI for relative ISI

[nISI, edges] = histcounts(ISIvec,200);
[logBins, logEdges] = histcounts(log10(ISIvec),100);

if display == 1
    close
    figure(1)
    histogram('BinEdges',edges,'BinCounts',nISI)
    figure(2)
    histogram(ISIvec,10.^logEdges)
    set(gca, 'xscale','log');
end

end