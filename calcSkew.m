%this function calculates the skewness

function skewness = calcSkew(preproVec)
N = length(preproVec);
power = preproVec.^3;
skewness = sum(power)/(N);
end

