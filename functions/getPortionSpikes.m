%similate to the function getConnectivity; but here the window is around
%one spike according to Cutts and Eglen 2014 J.Neuroscience

%TS is a double array or cell array

%Connectivity Matrix = nxm matrix with n=m and n,m being the number of
%active electrodes

function [P,C, numbSp] = getPortionSpikes(TS,Tdil)

numberEl = size(TS,2);
% swin = 12500 * win;
% dT = swin/2;
C = zeros(numberEl,numberEl);
numbSp = sum(TS,1); %number of spikes

for ch = 1:numberEl
    log = Tdil(:,ch);
    log = log == 1;
    number = sum(TS(log,:),1);
    C(ch,:)= number';
end

total = repmat(numbSp,numberEl,1);
P = C./total;
end