%This function calculates the offset lag time within a network burst
% input: dilated data from time stamp in the range of a network burst

function [offsetLag_avg, offsetLag_std] = getOffsetLagT(NBdil)

NBdil = [zeros(size(NBdil,1),1) NBdil];
NBdildiff = diff(NBdil);
% 1 indicates the start of a new burst

log = any(NBdildiff,1);
idxtemp = 1:1:size(NBdil,2);
idx = idxtemp(log);
offsetLag_avg = mean(diff(idx));
offsetLag_std = std(diff(idx));
end

