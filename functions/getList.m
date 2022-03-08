%getList is thought as a subfunction of MeaCalc, but can basically be used
%as a stand alone method to rearrange a spike List derived from the AXION
%spike List .csv file
% the single table column is sorted and rearranged and returns spike list
% with electrodes arranged columnwise and corresponding time points in rows

%-------------------------------------------------------------------------
%saving conditions: saving path and name must be indicated as input
%argument by the calling function; if not, output argument is not saved on
%harddrive
%--------------------------------------------------------------------------
% get List properties
%'instruction' : adjust the instruction of user interface
%'multiSelection': 'on' , 'off'
%'NameList': names of variables (names of electrodes) that must be selected;
%'folder','file' = path to the experiment files;
% 'saveName', 'savePath' = directory if output spike list should be saved

function [spikeList] = getList(varargin)

%define defaults:

instruction = 'insert file';
multiSelection = 'off';
flagSave = 1; %default for saving conditions

siz = size(varargin,2);

if mod(siz,2) ~= 0
    error ('wrong number of input arguments')
end
for i = 1:2:siz-1
    arg = varargin{i};
    switch arg
        case 'instruction'
            instruction = varargin{i+1};
        case 'multiSelection'
            multiSelection = varargin{i+1};
        case 'nameList'
            nameList = varargin{i+1};
        case 'folder'
            pathInfo = varargin{i+1};
        case 'file'
            fileInfo = varargin{i+1};
        case 'saveName'
            saveName = varargin{i+1};
        case 'savePath'
            savePath = varargin{i+1};
        otherwise
    end
end

if ~exist('fileInfo','var') || ~exist('pathInfo','var') || ...
        isempty(fileInfo) || isempty(pathInfo) 
    [fileInfo, pathInfo] = uigetfile('*.csv',instruction,'MultiSelect',multiSelection); %'Select list of spikes from AXION'
end

if ~exist('saveName', 'var') || ~exist('savePath','var')...
        || isempty(saveName) || isemtpy(savePath)
    flagSave = 0;
end

if ~iscell(fileInfo)
    fileInfo = num2cell(fileInfo,2);
end
numbExp = size(fileInfo,2);

%% preallocate data container
spikeList = repmat(struct('experiment',0),numbExp,1);

%% loop through experiments
for exp = 1:numbExp
   
    opts = detectImportOptions(fullfile(pathInfo,fileInfo{exp}));
    SelectedNames ={'Time_s_', 'Electrode', 'Amplitude_mV_'};
    opts.SelectedVariableNames = SelectedNames;
    spikeTable = readtable(fullfile(pathInfo,fileInfo{exp}),opts);
    numbSamples = height(spikeTable);
    
    completeNameList = spikeTable.(2);
    
    if  exist('nameList','var') == 0
        nameList = unique(completeNameList);
        numbEl = length(nameList) - 4;
        nameElectrodes = nameList(3:numbEl+2);
    else
        nameElectrodes = nameList;
        numbEl = length(nameElectrodes);
    end
    
    if numbSamples*numbEl <= 134217728
        spikePerEl = cell(numbSamples,numbEl); % create cell array for data storage
    else
        numbSamples = getMaxRow(numbEl);
        spikePerEl = cell(numbSamples,numbEl);
    end
    
    spikePerEl(1,:) = nameElectrodes;
    
    anz = 0;
    for n = 1:numbEl
        name = nameElectrodes{n};
        r = strcmp(completeNameList,name);
        spn = sum(r);
        if spn > anz
            anz = spn;
        end
        time = spikeTable.(1)(r);
        if length(time) >  numbSamples
            spikePerEl(2:end,n) = num2cell(time(1:numbSamples-1,1));
            warning('spikes in electrode nr.%i of experiment nr.%i does not fit into array size - interval will be cutted, respectively',n,exp);
        else
            spikePerEl(2:length(time)+1,n) = num2cell(time);
        end
    end
    
    spikeListInd = spikePerEl(1:anz,:);
    
    %put into containter:
    str2 = sprintf('experimentNr_%i',exp);
    if flagSave == 1
        expName = strcat(saveName,str2);
    else
        expName = fileInfo;
        expName = strrep(expName,'.csv','');
    end
    spikeList(exp,1).experiment = expName;
    spikeList(exp,1).data = spikeListInd;
    spikeList(exp,1).nameElectrodes = nameElectrodes;
    clearvars -except flagSave spikeList numbExp nameList saveName savePath fileInfo pathInfo exp
end

if flagSave == 1
    save(fullfile(savePath,saveName),'spikeList');
end

end

