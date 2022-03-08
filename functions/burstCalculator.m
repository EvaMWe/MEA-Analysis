% input: list is a struct container derived from burstDetection containing
% - start/stop indices
% - start/stop time stemps
% - spike number per burst
% - mean spike number
% - number of bursts per electrode
% - burstrate per electrode

function burstCalc = burstCalculator(list,interval)
%
nElectrodes = size(list,2); %non responding electrodes are excluded by baseline;

%% exclude non-bursting channels: MBR < burst/min
threshold = 1/60; %number of burst per second
rate = cell2mat(list(7,:));
idx = rate >= threshold;
listValid = list(:,idx);

%% number of bursts per well
nB = listValid(6,:);
sum_nB = sum(cell2mat(nB));

%% mean bursting rate MBR
MBR_well = sum_nB/interval;

%% weighted mean bursting rate wMBR
wMBR_well = (nElectrodes/length(idx))*MBR_well;

%% mean burst duration MBD
MBD_well = mean(cell2mat(listValid(8,:)));

%% mean number of spikes per burst per well MNSB_well
MNSB_well = mean(cell2mat(listValid(5,:)));

%%
burstCalc.n_of_bursts_per_well=sum_nB;
burstCalc.mean_bursting_rate_per_well=MBR_well;
burstCalc.weighted_MBR_per_well=wMBR_well;
burstCalc.mean_burst_duration=MBD_well;
burstCalc.mean_number_of_spikes_per_burst = MNSB_well;
end
%% 


