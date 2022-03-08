%This function calculates the connectivity matrix C and the correclation
% % matrix corr
% according to Wong et al, 1993 
% "The correlation index corrij between two spike trains A and B is defined as
% the factor by which the firing rate of channel A increases over its mean
% value if measured within a fixed window (default here 0.1 s) of spikes
% from neuron B (Wong et al., 1993)."  
%
% 1) calculation of connectivity matrix C:
% detection of spikes from electrode B that fall inside a synchronicity window around a
% particular spike from electrode A. The number of spike pairs on each
% electrode a summed up resulting in a square matrix C with the size
% nbElectrode x nbELectrode
% 
% 2) correlation indices are determined from C according to:
%    corr= C*T/(nbSpikes)*dT
%    nbSPikes is a square matrix from same size as C containing the product
%    of number of spikes of the corresponding pairs.

function [C, corr, numbSp] = getConMat(TS,varargin)
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
                if idx <= dT || idx >= size(TS,1) - dT  % boundary conditio: spikes too close to boundary are excluded
                    continue
                else
                    others = TS(idx-dT:idx+dT,ch+1:end);
                end
            else
                if idx <= dT || idx >= size(TS,1) - dT  % boundary conditio: spikes too close to boundary are excluded
                    continue
                else
                    %sprintf('spikeNr is %i',idx)
                    %sprintf('chNr is %i',ch)
                others = TS(idx-dT:idx+dT,[1:ch-1 ch+1:end]);
                end
            end
            count = sum(others,1);
            countAll = countAll + count;
        end
        if ch == 1
            C(ch,ch+1:end)=countAll;
        else
            C(ch,[1:ch-1 ch+1:end]) = countAll;
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


