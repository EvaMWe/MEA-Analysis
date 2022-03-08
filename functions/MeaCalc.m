%% MEA CALCULATION SOFTWARE PART 1

% (1) get spike List from the baseline (20-30min)
%       apply condition > 0.1 Hz spike rate to clean non-valid electrodes
% (2) pass valid spike list and calculate spike lists from other
%       experiments

function results = MeaCalc()

%% (0) insert files for baseline and experiments
[baseInfo, basePath] = uigetfile('*.csv','insert baseline file path',...
                                 'MultiSelect','off'); %'Select list of spikes from AXION'
[saveBaseName,saveBasePath] = uiputfile;
[expInfo, expPath] = uigetfile('*.csv','insert experiment file path','MultiSelect','on');
[saveName, savePath] = uiputfile;

%% (1)
firstList = getList('instruction','insert baseline files','multiSelection','off',...
                    'folder',basePath,'file',baseInfo,...
                    'saveName', saveBaseName, 'savePath', saveBasePath); %receive the spike list of baseline
validList = cleanData(firstList);

%% (2)
electrodeNames = validList(1,:)';
spikeList = getList('instruction','insert experiment files','multiSelection','on',...
                    'nameList',electrodeNames,'folder',expPath, 'file', expInfo,...
                    'saveName', saveName, 'savePath', savePath);

% spikeList is a struct containing all spike Lists of each calculated experiment

numbExp = length(spikeList);

%% (3) calculate individual spikes
for exp = 1:numbExp
    %data = spikeList(exp,1).

end
end