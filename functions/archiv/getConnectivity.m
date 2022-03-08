%this function returns the connectivity matrix from a time stamp array
%TS is a double array or cell array

%Connectivity Matrix = 16x16

function C = getConnectivity(TS,varargin)
if nargin == 2
    win = varargin{1};
else
    win = 0.1; %100 ms
end

numberEl = size(TS,2);
swin = 12500 * win;
C = zeros(numberEl,numberEl);
numbSp = sum(TS,1);


for ch = 1:numberEl
    spikeIdx = find(TS(:,ch) == 1);
    if numbSp(1,ch) == 0
        C(ch,:) = 0;
    else
    countAll = 0;   
        for i = 1:numbSp(1,ch)
            idx = spikeIdx(i);
            if ch == 1
                others = TS(idx:swin,ch+1:end);
            else
                others = TS(idx:swin, [1:ch-1 ch+1:end]);
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
end


