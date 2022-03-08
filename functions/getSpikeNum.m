%% calculates number of spikes per individual electrode

function numbSpikes = getSpikeNum(spikeList, varargin)

if iscell(spikeList)
    nSpikeMax = size(spikeList,1) -1; %there is a row with electrodes names in the cell array
    if nargin == 1
        emptyIndex = cellfun('isempty', spikeList);    
    elseif nargin == 2
        emptyIndex = varargin{1}; 
    else
        error ('wrong number of input arguments')
    end
    numbSpikes = nSpikeMax - sum(emptyIndex,1);
else
    nSpikeMax = size(spikeList,1);
    if nargin == 1
        emptyIndex = spikeList == 0;
    elseif nargin == 2
        emptyIndex = varargin{1}; 
    else
        error ('wrong number of input arguments')
    end
    numbSpikes = nSpikeMax - sum(emptyIndex,1);
    
end
end

