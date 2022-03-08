%this funtion is meant as intermediate function calculating the
%connectivity parameter STTC: mean, variance, skewness

function [fileNames, pathName]= statistics2STTC_GUI(varargin)
saveFlag = 'on';

if nargin ~= 0
    saveFlag = varargin{1};
end

[fileNames, pathName] = uigetfile('.mat','Select files for calculating statistic parameters of STTC'...
                                  , 'MultiSelect','on');
                              
if ~iscell(fileNames)
    fileNames = cellstr(fileNames);
end

nbM = length(fileNames);


for m = 1:nbM
    data = load(fullfile(pathName,fileNames{m}),'-mat');
    if isfield(data,'connectivity')
        data = data.connectivity;
    else
        data = data.data;
    end
    
    nWells = length (data);
    for well =1:nWells
        dataMat = data(well).STTC;
        dataMat_upper= triu(dataMat);
        dataMat_upper(dataMat_upper == 1) = 0;
        dataMat_upper(dataMat_upper == 0) = NaN;
        %dataMat_red = dataMat_upper(any(dataMat_upper,2),:);
        %dataMat_red2 = dataMat_red(:,any(dataMat_red,1));
        
        STTCvec = reshape(dataMat_upper',1,[]);
        STTCvec(isnan(STTCvec)) = [];
        meanSTTC = mean(STTCvec, 'omitnan');
        varSTTC = var(STTCvec, 'omitnan');
        skewSTTC = calcSkew(STTCvec);
        data(well).meanSTTC = meanSTTC;
        data(well).varSTTC = varSTTC;
        data(well).skewSTTC = skewSTTC;
    end
    if strcmp(saveFlag, 'on')
        save(fullfile(pathName, fileNames{m}), 'data');
    end
end
end