% dataRaw: row: time bin; col: means by group

function dataNorm = normalisingData_forSig(dataRaw, nbBaseVal)

%if nbBaseVal == 0 no baselineNormalization

baseLevel = mean(dataRaw(1:nbBaseVal,:));
dataNorm = dataRaw(nbBaseVal+1:end,:);
dataNorm_sub = dataNorm;
for sub = 1:size(dataNorm,1)
    dataNorm_sub(sub,:) = dataNorm(sub,:)./baseLevel;
end

MWs = 
