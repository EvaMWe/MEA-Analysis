% input: data...cell array with first row = name of electrodes
% (non-contributing electrodes in baseline are already excluded)

%returns a cell array with 
% 1. row: well names
% 2. row: cell array containing time stemps per electrode;

% optional, varargin: %minimum number of participating electrodes
% data = derived from electrodes
% 1. variable - exculding: number of minimum active electrodes; excludes
%                          wells that do not fullfil that condition
%                          -1: no excluding parameter
% 2. variable _ redlist: when a list of wells already exists, it can be
%                         insert here ['A1' A2' 'B1'....]
function [list,wellNames] = getWells(data, varargin)
%% classifier: first 2 literals indicate well number --> redNameList
%default

nameList = data(1,:);

if nargin >= 2          %minimum number of participating electrodes
    excluding = varargin{1};
    if excluding == -1
        clear excluding
    end
end

if nargin == 3
    redList = varargin{2};
    redList = num2cell(redList);
end

numbEl = length(nameList);
if ~exist('redList','var')
   
        redNameList = nameList;
        for el = 1:numbEl
            redNameList{el} = nameList{el}(1:2);
        end
        
        %% reduce to single names (no doubles)
        redList = unique(redNameList); %reduce to unique expressions
      
end


nWells = length(redList);


%% compare lists and group together
list = cell(3,nWells);

for well = 1:nWells
    el = redList(well);
    if iscell(el)
        el = el{1};
    end
    list{1,well} = el;
    r = zeros(1,length(nameList));
    for c = 1:length(nameList)
        r(1,c) = strcmp(nameList{1,c}(1:2),el);       
    end
    idx = (find(r));
    array = data(:,idx);
    list{2,well} = array;
    list{3,well} = 1;
    if exist('excluding','var') && size(array,2) < excluding
        list{3,well} = 0;   
    end       
end
test = cell2mat(list(3,:)) ;
idx = find(test == 0);
list(:,idx) = []; 
list = list(1:2,:);

wellNames = list(1,:);
end

