%similate to the function getConnectivity; but here the window is around
%one spike according to Cutts and Eglen 2014 J.Neuroscience

%TS is a double array or cell array

%Connectivity Matrix = nxm matrix with n=m and n,m being the number of
%active electrodes

function [corr, numbSp] = getCorrMat(TS,varargin)
if nargin == 2
    win = varargin{1};
else
    win = 0.1; %100 ms
end

numberEl = size(TS,2);
swin = 12500 * win;
dT = swin/2;
C = zeros(numberEl,numberEl);
numbSp = sum(TS,1); %number of spikes

for ch = 1:numberEl
    spikeIdx = find(TS(:,ch) == 1);
    if numbSp(1,ch) == 0
        C(ch,:) = 0;
    else
    countAll = 0;   
        for i = 1:numbSp(1,ch)
            idx = spikeIdx(i);
            if ch == 1
                if idx <= dT || idx > size(TS,1)  % boundary conditio: spikes too close to boundary are excluded
                    continue
                else
                    others = TS(idx-dT:idx+dT,:);
                end
            else
                if idx <= dT || idx >= size(TS,1) - dT  % boundary conditio: spikes too close to boundary are excluded
                    continue
                else
                others = TS(idx-dT:idx+dT,:);
                end
            end
            count = sum(others,1);
            countAll = countAll + count;
        end
        if ch == 1
            C(ch,:)=countAll;
        else
            C(ch,:) = countAll;
        end
        clearvars countAll;
    end


 
end
  %calculate the correlation coefficients according
    %to:corr(ij) = C*T/numbSp(i)*numbSpike(j)*dT
    % denominator: den
  T = size(TS,1);
   corr = C.*T;
   denVec = sum(TS,1);
   den = (repmat(denVec',1,length(denVec))* diag(denVec)).*dT;
   corr = corr./den;
end


