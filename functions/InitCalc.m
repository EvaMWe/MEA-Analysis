
function [base_cal] = InitCalc(data)
base_cal.data = data;
[value] = PeakOrBurst(data,0);
if value >= 19
    base_cal.type = 'burst';
else
    base_cal.type = 'peak';
end

if strcmp(base_cal.type,'peak')
    base_cal.winbig = 10;
    base_cal.winsmall = 5;
elseif strcmp(base_cal.type,'burst')
    base_cal.winbig = 100;
    base_cal.winsmall = 30;
else
    disp('error: enter valid value for type')
    return
end

base_cal.frames = length(base_cal.data);
% [deviation] = noise_std (data, 0,5);
% base_cal.noise = deviation;
% base_cal.threshfactor = 1.3*deviation;
base_cal.flag = 'bursteval_off';
base_cal.onset = 1;
base_cal.detection = 'on';
base_cal.polyfitdegree = 3;
base_cal.showplot = 1;
base_cal.exist='filling';
base_cal.framerate = length(data)/300; %in Hz
end

