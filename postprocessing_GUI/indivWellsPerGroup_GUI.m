% this function will creat an array to plot traces from individual curves
% but grouped
%
% dataArray WxTxGr (W = wells/datapoints;T = bins/time, Gr = groups) (1:length(temp),bin,gr) = temp;
% fstart should be 4 in the case of connectivity; 3 first fields are the
% correlation matices;
function dataStore= indivWellsPerGroup_GUI(dataStruct, varargin)
fstart = 1;

if nargin ~= 1
    fstart = varargin{1};
end
nbBins = length(dataStruct);


%get fieldnames
features = fieldnames([dataStruct.data_for_statistic]);
nbF = length(features);
nbGr = size(dataStruct(1).data_for_statistic.(features{1}),2);
groupNames = dataStruct(1).data_for_statistic.(features{1});
groupNames = groupNames(2,:);
nbT = length(dataStruct);
binNames = {nbT,1};
for t = 1:nbT
    binNames(t,1) = {sprintf('t_%i',t)};
end

nbWells = numel(dataStruct(1).data_for_statistic.(features{1})(3:end,1));

dataStore = repmat(struct('featureName',[]),1,nbF);
dataArray = zeros(nbWells,nbBins,nbGr);
for f = fstart:nbF
    
    for gr = 1:nbGr
        
        for bin = 1:nbBins
            temp = cell2mat(dataStruct(bin).data_for_statistic.(features{f})(3:end,gr));
            dataArray(1:length(temp),bin,gr) = temp;
            
        end
        
    end
    
    dataStore(f-fstart+1).featureName = features(f);
    dataStore(f-fstart+1).dataArray = dataArray;
    dataStore(f-fstart+1).groupNames = groupNames;
    
end
dataStore = dataStore(1:f-fstart+1);
%% visualization
% for f = fstart:nbF
%     visualizationIndivWells(dataStore(f).dataArray, dataStore(f).featureName, nbGr, groupNames, binNames);
% end

end

function visualizationIndivWells(data, featureName, nbGr, groupNames, binNames)
colormap colorcube
cmap = colormap;
fig = figure('Name',featureName{1}, 'NumberTitle','off');
%fig.MenuBar = 'none';
fig.Color = [1 1 1];
ax = gca;


ax.XTickLabel = binNames;
ax.XTick = 1:1:length(binNames);
ax.TickDir = 'out';
ax.XTickLabelRotation = 90;
ax.FontSize = 8;
%ylabel({Ylabel},'FontSize',14);
hold on
for g = 1:nbGr
    arrayLong = data(:,:,g);
    array = arrayLong(any(arrayLong,2),:);
    %ax = gca;
    %ax.ColorOrder = cmap(g,:);
    plot(array','-s','MarkerSize',6,'LineWidth',1.5,'Color',cmap(g+2,:))
  
    legend(groupNames{1,g})
    hold on
end
end

