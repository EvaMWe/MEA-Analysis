nbBin = size(PCA_featureRelevance,3);
[filename,pathName] = uiputfile;

for bin = 1:nbBin
values = PCA_featureRelevance(:,:,bin);
sheetName = sprintf('time unit %i',bin);
saveName = strcat(fullfile(pathName,filename),'.xlsx');
    warning('off','MATLAB:xlswrite:AddSheet');  
    writetable(cell2table(values),saveName,'WriteVariableNames',false,...
    'Sheet',sheetName);
end