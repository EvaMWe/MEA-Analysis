% this function detects network bursts accross a cultured network on a MEA
% well and calculate some standard parameters 
% input: time stamp matrix: a binary array indicating spikes, can be
% received from the function getTimeStamp; data corresponds to one well
% (1) get network bursts candidates
%     - dilate the time stamp of each electrode by a linear structural
%     element with len = 1250 (equal to 100 ms), with the origin is most
%     right data point within the kernel
%     - any zeros in one row?
%     - get logical vector: 0 - no signal, indicates endpoint after subtracting 1250 
%                           1 - potential NB
%     - diff of that logical vector: 1 indicates starting point, -1
%     indicates end point (but 1250 has to be subtracted to get the real
%     endpoint due to prior dilation
%
%     if length of vector containing endings is shorter than vector
%     containing starts---check if burst ends before measurement ends and
%     add the end point; otherwise add last point of measurment as stop for
%     the burst
%     
%-------------------------------------------------------------------------------
% (2) apply further conditions to select the real NBs
%     spike number > 50
%     number of contributing electrodes > 5
%     in that course saving of spike number per NB and number of
%     contributing electrodes per NB for later calculations
%
%-------------------------------------------------------------------------------
% (3) calculate parameters and output as a struct
%
%!!!!OUTPUT!!!!!!----DATA STRUCT CONTAINING NETWORK BURST DATA
% number_of_NB = nNB;
% duration_of_one_NB = durationNB;
% average_duration_of_NB =durationNB_avg;
% standardDeviation_duration_of_NB = durationNB_std;
% number_of_spikes_per_NB = numbSpike;
% average_number_of_spikes = avgNumbSpikes;
% stdNumbSpikes = stdNumbSpikes;
% number_of_contr_channels = numbEl;
% average_nb_of_contr_channele = avgPartEl;
% standardDeviation_of_contr.channels = stdPartEl;
% summary = NBcell;
%
% HINT: summary: a nxm cell array containing duration, number of spikes and number of contributing electrodes 

function result = networkBurstCalculator(TS)

nCh = size(TS,2);
nSample = size(TS,1);
len = 1250; % defined by default = 100ms with sampling rate 12.5 kHz
%% (1) Get network burst
%% Dilate in 1-D
%  MAYBE VECTORIZE THAT PART??
TSdil = zeros(size(TS));

for ch = 1:nCh     
     t = TS(:,ch);
     tDil = dil_1D(t,len);
     TSdil(:,ch) = tDil;
end

%% get non-zero rows
sLog = any(TSdil,2);
sLogDiff = diff(sLog);
NBstart = find(sLogDiff == 1) + 1;
NBstop = find(sLogDiff == -1) + 1 -len; %subtract 1250 because of the dilation

if length(NBstart) > length(NBstop)
   checkEnd = any(TS(end-len+1:end,:),2);%check if there is a burst end, before measurement stops 
   lastEnd = find(checkEnd, 1, 'last')+nSample-len;
   NBstop = [NBstop; lastEnd];
end

nNB = length(NBstart);

%% apply further conditions: more than 5 spikes, at least 5 electrodes contributing

NBstartOrg = NBstart;
NBstopOrg = NBstop;
numbSpike = zeros(nNB,1);
numbEl = zeros(nNB,1);
NB_stamps = cell(nNB,1);
count = 0;
nElAbs = 0;
for  n = 1:nNB
    start = NBstartOrg(n);
    stop = NBstopOrg(n);
    nSP = sum(sum(TS(start:stop,:)));  
    % delete from list if condition is not met
    if nSP < 50 % condition nSpikes > 50
        NBstart(n-count) = [];
        NBstop(n-count) = [];
        numbSpike(n-count) = [];
        numbEl(n-count) = [];
        NB_stamps(n-count) = [];
        count = count+1;
    else 
        nNonZero =sum(any(TS(start:stop,:),1),2); % participating electrodes > 5
        if nNonZero < 5
            NBstart(n-count) = [];
            NBstop(n-count) = [];
            numbSpike(n-count) = [];
            numbEl(n-count) = [];
            NB_stamps(n-count) = [];
            count = count+1;
        else
            nElAbs = nElAbs+nNonZero; % total number of contributing electrodes
            numbSpike(n-count) = nSP; %get number of spikes per NB
            numbEl(n-count) = nNonZero; %get number of contributing electrodes
            matrixNB = TSdil(start:stop,:);
            NB_stamps{n-count} = matrixNB;
        end        
    end    
end

%some statistics:
nNB = length(NBstart);
durationNB = NBstop-NBstart;
durationNB_avg = mean(durationNB);
durationNB_std = std(durationNB);
avgNumbSpikes = mean(numbSpike); %average of number of spikes
stdNumbSpikes = std(numbSpike);
avgPartEl = mean(numbEl);
stdPartEl = std(numbEl);

%make a cell array for fast access and indexing:
NBcell = cell(5,nNB+1);
NBcell(1,2:end) = num2cell(1:1:nNB);
rowVar = {'networkburst Nr.:'; 'duration of NB [/12.5*10^3 sec]';...
    'n spikes';'n contributing channels';'dilated stamp of NB'};
NBcell(:,1) = num2cell(rowVar);
NBcell(2,2:end) = num2cell(durationNB);
NBcell(3,2:end) = num2cell(numbSpike);
NBcell(4,2:end) = num2cell(numbEl);
NBcell(5,2:end) = NB_stamps;


% put into a data struct for storage
result.number_of_NB = nNB;
result.duration_of_one_NB = durationNB;
result.average_duration_of_NB =durationNB_avg;
result.standardDeviation_duration_of_NB = durationNB_std;
result.number_of_spikes_per_NB = numbSpike;
result.average_number_of_spikes = avgNumbSpikes;
result.stdNumbSpikes = stdNumbSpikes;
result.number_of_contr_channels = numbEl;
result.average_nb_of_contr_channele = avgPartEl;
result.standardDeviation_of_contr.channels = stdPartEl;
result.NBstamps_dilated = NB_stamps;
result.summary = NBcell;


end

