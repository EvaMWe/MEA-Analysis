function spikeRateArray = conversion(spikeList, decl)

switch decl
    for decl == 1
        emptyIndex = cellfun('isempty', spikeList);
