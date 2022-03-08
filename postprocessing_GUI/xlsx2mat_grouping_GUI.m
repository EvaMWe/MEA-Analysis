% This is a tool to extract the processed Data by main_MEA_Axion by group
% input is a List of groups provided as an Excel sheet containing the group
% names as variable names with the belonging wells 
% NAME PROPERTY PAIRS
% 'sheetname' - name of the spreadsheet that has to be read in
% 'nbGroups' - number of groups [scalar]
% 

function cellWithGroups = xlsx2mat_grouping_GUI(sheetname, nbGroups, variableNames, groupingFile)
%% defaults

opts = detectImportOptions(groupingFile);
if ~isnan(str2double(sheetname))
    sheetname =str2double(sheetname);
end
opts.Sheet = sheetname;
opts.DataRange = 'A3';
if exist('variableNames','var')
    opts.VariableNames = variableNames;
end
opts.SelectedVariableNames = opts.VariableNames(1:nbGroups);
for vari = 1:nbGroups
opts.VariableTypes{1,vari} = 'char'; 
end
TableOfGroups = readtable(groupingFile,opts);
subCell =table2cell(TableOfGroups);
cellWithGroups = cat(1,opts.SelectedVariableNames, subCell);
end



