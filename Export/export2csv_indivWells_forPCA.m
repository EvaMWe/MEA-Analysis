%function that will prepare the grouped Data for excel export
% here the groupes are averaged within one bin, since there is no treatment
% applied and the values are treated as independent from time
%input: data.meanSum: double array WxTx2 (wells x timePoints x groups)
%       data.stdSum


function export2csv_indivWells_forPCA(varargin)

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
    [fileName, pathName] = uiputfile('*.xlsx','Select saving folder');
end

nbGroups = size(data(1).meanSum,3);
nbBin = size(data(1).meanSum,2);
nbWells = size(data(1).meanSum,1);
nbFeatures = length(data);

fileName = extractBefore(fileName, '.');
saveName = strcat(fullfile(pathName,fileName),'.xlsx');

for f = 1:nbFeatures-1
    groupNames = data(f).groupNames;
    sheetName = data(f).featureName{1};
    values = cell(nbBin+1,nbWells);
    remember = 1;
    for g = 1:nbGroups
        groupName = groupNames{g};
        arrayLong = data(f).meanSum(:,:,g);
        array = arrayLong(any(arrayLong,2),:);
        nwells = size(array,1);
        values(1,remember) = {groupName};
        values(2:end,remember:remember + nwells -1) = num2cell(array');
        remember = remember + nwells;
    end
    
   
    warning('off','MATLAB:xlswrite:AddSheet'); 
    units = values(1,:);
    values_ = values(2:end,:);
    writetable(cell2table([num2cell(units);num2cell(values_)]),saveName,'WriteVariableNames',false,...
    'Sheet',sheetName);
end

fracVar = cell2table(data(nbFeatures).fractionOfVariance_Info);
writetable(fracVar,saveName,'WriteVariableNames',false,...
    'Sheet','FractionOfVariance');
%% store the fraction of variance per bin
end


