function FC = init_featureCell(wellNb, wellNames, nbBins)

featurelist = load('featureTable.mat');
rowNames = cellstr(table2array(featurelist.featurelist));
row_n = length(rowNames);
FC = cell(row_n+1,wellNb+1);
FC(2:end,1) = rowNames;
FC(1,2:end) = wellNames;
FC = repmat(FC,1,1,nbBins);
end



