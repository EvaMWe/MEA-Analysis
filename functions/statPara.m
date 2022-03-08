function [MW, CV, Skew] = statPara(data)
MW = mean(data);
CV = var(data)/MW;
Skew = skewness(data);
end