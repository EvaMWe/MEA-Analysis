% t is an array defining the bins and timepoints to summarize

function [dataStore] = groupingIndays_GUI(dataStore,varargin)

data_scale = dataStore(1).dataArray;
nbGroups = size(data_scale,3);
nbFeatures = length(dataStore);
nbwells = size(dataStore(1).dataArray,1);
if nargin > 1
    timepoints = varargin{1,1};
    nbPeriods = size(timepoints,1);
else
    nbPeriods = 1;
    timepoints = [1, length(dataStore)];
end

for f = 1:nbFeatures
    
    
    meanData = zeros(nbwells,nbPeriods,nbGroups);
    stdData = zeros(nbwells,nbPeriods,nbGroups);
    
    dataArray= dataStore(f).dataArray;
    
    
    
    for p = 1:nbPeriods
        t = timepoints(p,1):timepoints(p,2);
        dataStore(f).(sprintf('period_%i',p)) = dataArray(:,t,:);
        for ms = 1:nbGroups
            meanData(:,p,ms) = mean(dataArray(:,t,ms),2,'omitnan');
            stdData(:,p,ms) = std(dataArray(:,t,ms),0,2,'omitnan');
        end
    end
    
    dataStore(f).meanSum = meanData;
    dataStore(f).stdSum = stdData;
    
    %
end
end
