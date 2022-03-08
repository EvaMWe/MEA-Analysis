%This is a function calcualting a threshold using entered electrodes;
%This could be a single electrode, but also all electrodes involved in one
%network. If serveral electrodes are selected, the ISI histogram is
%calculated

function idxCMA = calcCMA(nBin)
L =1:length(nBin);
CH = cumsum(nBin);
CMA =CH./L;
[maxCMA,idxCMA] = max(CMA);
%X_line = 10.^(edges(1:end-1)) + diff(10.^edges)./2;
%figure,hold on
%plot(X_line,CMA);
end
    