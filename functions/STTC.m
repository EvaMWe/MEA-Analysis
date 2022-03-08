function STTC_array = STTC(TS,varargin)

% calculate proportion of total time
nCh = size(TS,2);
Tabs = size(TS,1);
Tprop = zeros(nCh,1);
tic
if nargin == 3
    len = varargin{2};
    Tdil = varargin{3};
elseif nargin == 2
    len = varargin{2};
elseif nargin == 1
    len = 1250;
end

if nargin == 1 || nargin == 2
   se = strel('line', len, 90); 
   Tdil = imdilate(TS,se);
end

Tprop(:,1) = sum(Tdil,1)./Tabs;
toc

%calculate proportion of spikes
P = getPortionSpikes(TS, Tdil);

%get term 1
differences = P-Tprop;
factor =-(P.*Tprop(:))+1;
diffNorm = differences./factor;

%(P-Tprop)./(-(C./Tprop(:))+1);
STTC_array = 1/2*(diffNorm + (diffNorm)');

end
    