% input: spikeData is a cell array with spike stemps per electrode
% results = burstDetector(spikeData, interval)
% results = burstDetector(spikeData, interval, methode)
% results = burstDetector(spikeData, interval, [maxISI, minNS])
%
% methode; 'detCMAIndiv'
function results = burstDetector(spikeData, interval, varargin)
%default 

minNS = 5;
maxISI = 0.100;
spikeArray = conversion(spikeData, 1);
numbEl = size(spikeArray,2);

% dynamic threshold or other threshold than default
if nargin > 2 
    if isstring(varargin{1})
       command = varargin{1};
       switch command
           case 'detCMAIndiv'
               maxISI =CMA_burstDet(spikeData);
           otherwise
       end
    else
        maxISI = varargin{1}(1);
        minNS = varargin;
    end
end

%% extract list of time stemps
sumResult = cell(10,numbEl+1);
sumResult(1,2:end) = spikeData(1,:);
VariableNames = {'electrodes';'indices of starts and ends';...
                  'time stamp of start and ends'; 'Number of Spikes per Burst';...
                  'Mean Number of Spikes per Burst';'Standard Deviation of Spikes per Burst';...
                  'Number of Bursts'; 'Burst Frequency';...
                  'Mean Burst Duration'; 'Standard Deviation of Burst Duration'};
sumResult(:,1) = VariableNames;

for el = 1:numbEl
    sp = spikeArray(:,el);
    sp(sp == 0) = [];
    ISI = diff(sp);
    cond = ISI <= maxISI; %seconds
   %% construct an evaluation matrix to get minimal spike counts
   evMat = getArray(cond,minNS);
   %% get locations of burst
   summa = sum(evMat,1); %give the row wise sum; as soon as value is equal as min NS, 
                         % the number of spikes is reached (it's the
                         % minNS'th spike)
   logSum = summa == minNS;  % gives logical vector indicating the matches (number of spikes
                             % would be: number of 1s + 4 per burst;
   tempStart = diff(logSum);
   starts = (find(tempStart == 1)) - (minNS-1)+1;
   stops = (find(tempStart == -1));
   tstart = sp(starts);
   tstop = sp(stops);
   spike_numb = stops-starts+1;
   bursts_idx = cat(2,starts',stops');
   bursts_ti =  cat(2, tstart, tstop);
   MSN = mean(spike_numb);
   StdSN = std(spike_numb);
   nBurst = size(bursts_idx,1);
   if nBurst == 0
       MBD = 0;
       StdBD = 0;
   else
       MBD = mean(bursts_ti(:,2)-bursts_ti(:,1));
       StdBD = std(bursts_ti(:,2)-bursts_ti(:,1));
   end
    
   %put into container
  
   sumResult{2,el+1} = bursts_idx;   
   sumResult{3,el+1} = bursts_ti;
   sumResult{4,el+1} = spike_numb;  
   sumResult{5,el+1} = MSN;
   sumResult{6,el+1} = StdSN;
   sumResult{7,el+1} = nBurst;
   sumResult{8,el+1} = nBurst/interval;
   sumResult{9,el+1} = MBD;
   sumResult{10,el+1}= StdBD;
end

results.burst_indices = sumResult(2,2:end);
results.burst_timepoints = sumResult(3,2:end);
results.burst_spike_numb_pBrust = sumResult(4,2:end);
results.mean_spike_number = sumResult(5,2:end);
results.standard_deviation_MSN = sumResult(6,2:end);
results.number_of_bursts = sumResult(7,2:end);
results.burst_frequency = sumResult(8,2:end);
results.mean_burst_duration = sumResult(9,2:end);
results.standard_deviation_MBD = sumResult(10,2:end);
results.summary_of_Results = sumResult;
end
    
    
    
    
