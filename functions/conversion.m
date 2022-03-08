% this function includes some functions to convert and rearrange an array
% decl = 1: convert cell array to double array (first calculate empty
% fields, replace them with 0, and convert
% decl = 2: convert cell array or double array to a vector;

function [spikeArray,emptyIndex] = conversion(spikeList, decl)
emptyIndex = 0;
switch decl
    case 1
        emptyIndex = cellfun('isempty', spikeList);
        spikeList(emptyIndex) = {0};
        spikeArray = cell2mat(spikeList(2:end,:));
        
    case 2
        if iscell(spikeList)
           emptyIndex = cellfun('isempty', spikeList);
            spikeList(emptyIndex) = {0};
            spikeList = cell2mat(spikeList(2:end,:));            
        end
        vec = reshape(spikeList,1,[]);
        vec(vec == 0) = [];
        spikeArray = vec;
    otherwise
        error('invalide input arguements')
end

end
