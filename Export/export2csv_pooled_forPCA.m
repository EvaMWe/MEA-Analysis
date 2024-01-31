%function that will prepare export PC1 and PC2 into excel file
% direction:
    %1 - time
    %2 - well and group


function export2csv_pooled_forPCA(varargin)

if nargin == 0
    [fileName,pathName]= uigetfile();
    data = load(fullfile(pathName,fileName));
    data = data.stat_PCA;
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

nbGroups = size(data(1).data_for_statistic.PC1,2);
nbBin = size(data,2);
nbWells_max = size(data(1).data_for_statistic.PC1,1)-2; %maximal number of wells per group /-2 -> minus headings
nbFeatures = length(data(1).variance); %equvivalent number PC

fileName = extractBefore(fileName, '.');
saveName = strcat(fullfile(pathName,fileName),'.xlsx');

groupNames = data(1).data_for_statistic.PC1(2,:);

PC1 = cell(nbBin+1,nbWells_max*nbGroups);
PC2 = cell(nbBin+1,nbWells_max*nbGroups);


pos = zeros(nbGroups,1);
pos(1) = 1;
for idx = 2:nbGroups
    pos(idx) = pos(idx-1)+nbWells_max;
end
%pos2 = pos + 23;
PC1(1,pos)=groupNames;
PC2(1,pos)=groupNames;

for bin = 1:nbBin
    dat = data(bin).data_for_statistic.PC1(3:end,:);
    dat2 = data(bin).data_for_statistic.PC2(3:end,:);
    for group = 1:nbGroups
        datLine = cell2mat(dat(:,group));
        datLine2 = cell2mat(dat2(:,group));
        PC1(bin+1,pos(group):pos(group)+length(datLine')-1) = num2cell(datLine'); 
        PC2(bin+1,pos(group):pos(group)+length(datLine2')-1) = num2cell(datLine2'); 
    end
end

%reduce size by deleting empty columns
PC1(:, all(cellfun(@isempty, PC1), 1)) = [];
PC2(:, all(cellfun(@isempty, PC2), 1)) = [];

%%create the fraction of variance sheet:

%preall
fractVar = cell(nbFeatures+1, nbBin +1);
fractVar(1,1) = {'Principle Comp'};
for pc = 2:nbFeatures+1
    fractVar(pc,1) = {sprintf('PC_%i',pc-1)};
end
for tim = 2:nbBin+1
    fractVar(1,tim) = {sprintf('time unit %i',tim-1)};
    fractVar(2:end,tim) = num2cell(data(tim-1).variance);
end

%% write into excel table
PC1Tab = cell2table(PC1);
PC2Tab = cell2table(PC2);
fracVarTab = cell2table(fractVar);

 warning('off','MATLAB:xlswrite:AddSheet'); 
writetable(PC1Tab,saveName,'WriteVariableNames',false,'Sheet','PC1');
writetable(PC2Tab,saveName,'WriteVariableNames',false,'Sheet','PC2');
writetable(fracVarTab,saveName,'WriteVariableNames',false,'Sheet','FractionOfVariance');
% 
% sheetName = data(f).featureName{1};
%     values = cell(nbBin+1,nbWells);
%     remember = 1;
%     for g = 1:nbGroups
%         groupName = groupNames{g};
%         arrayLong = data(f).meanSum(:,:,g);
%         array = arrayLong(any(arrayLong,2),:);
%         nwells = size(array,1);
%         values(1,remember) = {groupName};
%         values(2:end,remember:remember + nwells -1) = num2cell(array');
%         remember = remember + nwells;
%     end
%     
%    
%     warning('off','MATLAB:xlswrite:AddSheet'); 
%     units = values(1,:);
%     values_ = values(2:end,:);
%     writetable(cell2table([num2cell(units);num2cell(values_)]),saveName,'WriteVariableNames',false,...
%     'Sheet',sheetName);
% end
% 
% % fracVar = cell2table(data(nbFeatures).fractionOfVariance_Info);
% % writetable(fracVar,saveName,'WriteVariableNames',false,...
% %     'Sheet','FractionOfVariance');
% % %% store the fraction of variance per bin
% % end


