% input: list is a struct container derived from burstDetection containing
% - start/stop indices
% - start/stop time stemps
% - spike number per burst
% - mean spike number
% - number of bursts per electrode
% - burstrate per electrode

function burstCalc = burstCalculator_perWell(listOfwells,interval)
%
numWell = length(listOfwells);
wellNames = listOfwells(1,:);

%% create summary cell
sum_Well = cell(8, numWell+1);
variableNames = {'number of bursts per well';' mean bursting rate MBR'; 'weighted mean bursting rate wMBR';...
    'mean burst duration MBD'; 'standard deviation of burst duration';'mean number of spikes per burst per well MNSB_well';...
    'standard deviation of spikes per burst per well '};
sum_Well(2:end,1) = variableNames;
sum_Well(1,2:end) = wellNames;

%% start loop through all wells
NumbBurst = zeros(1,numWell);
MBR = zeros(1,numWell);
wMBR = zeros(1,numWell);
MBD = zeros(1,numWell);
SdBD = zeros(1,numWell);
MNSB = zeros(1,numWell);
SdNSB = zeros(1,numWell);

for well = 1:numWell
    list = listOfwells{2,well};
%% cleaning data: exclude non-bursting channels: MBR < burst/min
    nElectrodes = size(list,2); %non responding electrodes are excluded by baseline;
    rate_th = 1/60; %number of burst per second
    dur_th = 1; %threshold for burst duration, to avoid discarding long bursts 
    rate = cell2mat(list(8,1:end));
    dur = cell2mat(list(9,1:end));
    idx = rate >= rate_th | dur > dur_th;
    listValid = list(:,idx);    
    
    %% number of bursts per well
    nB = listValid(7,:);
    sum_nB = sum(cell2mat(nB));
    NumbBurst(1,well) = sum_nB;
    
    %% mean bursting rate MBR
    MBR_well = sum_nB/interval;
    MBR(1,well) = MBR_well;
    
    %% weighted mean bursting rate wMBR
    wMBR_well = (nElectrodes/length(idx))*MBR_well;
    wMBR(1,well) = wMBR_well;
    
    %% mean burst duration MBD
    MBD_well = mean(cell2mat(listValid(9,:)),'omitnan');
    MBD(1,well) = MBD_well;
    
    %% standard deviation of burst duration
    std_BD_well = std(cell2mat(listValid(9,:)),'omitnan');
    SdBD(1,well) = std_BD_well;
    
    %% mean number of spikes per burst per well MNSB_well
    MNSB_well = mean(cell2mat(listValid(5,:)),'omitnan');
    MNSB(1,well) = MNSB_well;
    
    %% standard deviation of spikes per burst per well
    std_NSB_well = std(cell2mat(listValid(5,:)),'omitnan');
    SdNSB(1,well) = std_NSB_well;

end
burstCalc.numberOfBursts_perWell = NumbBurst;
burstCalc.mean_burst_rate_perWell = MBR;
burstCalc.weighted_MBR_perWell = wMBR;
burstCalc.mean_burst_duration_perWell = MBD;
burstCalc.standardDeviation_burst_duration_perWell = SdBD;
burstCalc.mean_number_of_spikes_per_burst_perWell = MNSB;
burstCalc.standardDeviation_numb_of_spikes_per_burst_perWell = SdNSB;

sum_Well(2,2:end) = num2cell(NumbBurst);
sum_Well(3,2:end) = num2cell(MBR);
sum_Well(4,2:end) = num2cell(wMBR);
sum_Well(5,2:end) = num2cell(MBD);
sum_Well(6,2:end) = num2cell(SdBD);
sum_Well(7,2:end) = num2cell(MNSB);
sum_Well(8,2:end) = num2cell(SdNSB);

burstCalc.summary_of_Results = sum_Well;
end
%% 


