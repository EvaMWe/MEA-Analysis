%function that will prepare the grouped Data for excel export

function export2csv_indivWells_Grouped(varargin)

if nargin == 0
    [fileName,pathName]= uigetfile();
    data = load(fullfile(pathName,fileName));
end

if nargin >= 1 
    data = varargin {1};
end

if nargin == 2
    fileName = varargin{2}(1);
    pathName = varargin{2}(2);
elseif nargin == 3
    fileName = varargin{2};
    pathName = varargin{3};
else    
    [fileName, pathName] = uiputfile;
end

nbGroups = size(data(1).dataArray,3);
nbBin = size(data(1).dataArray,2);
nbWells = size(data(1).dataArray,1);
nbFeatures = length(data);

for f = 1:nbFeatures
    groupNames = data(f).groupNames;
    sheetName = data(f).featureName{1};
    values = cell(nbBin+1,nbWells);
    remember = 1;
    for g = 1:nbGroups
        groupName = groupNames{g};
        arrayLong = data(f).dataArray(:,:,g);
        array = arrayLong(any(arrayLong,2),:);
        nwells = size(array,1);
        values(1,remember) = {groupName};
        values(2:end,remember:remember + nwells -1) = num2cell(array');
        remember = remember + nwells;
    end
    
    saveName = strcat(fullfile(pathName,fileName),'.xlsx');
    warning('off','MATLAB:xlswrite:AddSheet');  
    writetable(cell2table(values),saveName,'WriteVariableNames',false,...
    'Sheet',sheetName);
end
end


