% this function calculates a threshold for minimum inter spike interval
% witihing a burst.For that the cumulative histogram is calculated over the
% whole network
% spikeArray: cell array with electrode names in the first row

function[maxISI] = CMA_burstDet(spikeData)

[list,~] = getWells(spikeData,10);
maxISI = zeros(1,length(list));
%start loop through  

for well = 1:length(list)
    curWel = list{2,well};
    [~, edges, logBins, ISImean,ISIvec] = histCalc(curWel,1);    
    %% check for invalide high spiking channels
    [~,maxValues] = Maximum_median(ISIvec,80,'Dimension',2,'Type','percent'); 
    [~,Values] = Minimum_median(maxValues,95,'Dimension',2,'Type','percent');
                
    averageISI = mean(Values);
    
    thresh = 0.2*averageISI;
    exceeders = ISImean < thresh;
    if sum(exceeders) ~= 0
        curWel(repmat(exceeders,size(curWel,1),1))=[];
        clean
        [~, edges, logBins, ~] = histCalc(curWel,1); 
    end
    
    %% create ISI curve
    medLog = movmedian(logBins,3);
    smthLog = smooth(medLog)';
    X_line = 10.^(edges(1:end-1)) + diff(10.^edges)./2;
    hold on
    plot(X_line,smthLog)
    set(gca, 'xscale','log')
    
    
    CMA = calcCMA(logBins);
    maxISI(1,well) = CMA;
end
end

        
        

% idx_S = zeros(nEl,1);
% for ch = 1:nEl
%     ISI_vec=ISI_array(:,ch);
%     ISI_vec(ISI_vec <= 0) =[];
%     ISI_vec = round(ISI_vec.*12000); %[samples]
%     
%     [nISI, edges] = histcounts(ISI_vec,200);
%     figure(1)
%     histogram('BinEdges',edges,'BinCounts',nISI)
%     
%     
%     [logBins, edges] = histcounts(log10(ISI_vec),100);
%     figure(2)
%     histogram(ISI_vec,10.^edges)
%     set(gca, 'xscale','log')
%     CMA = calcCMA(logBins);
%     
%     idx_S(ch,1) = CMA;
%     
% end
% end
%     