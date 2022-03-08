function baseline = baseRef(baseline, SE, grad)
cutWin = 5;
base = smooth(baseline)';
base1 = imfilter(base, grad);
base2 = imfilter(base1, grad);



base_c = base(1,cutWin:end-cutWin);
base1_c = base1(1,cutWin:end-cutWin);
base2_c = base2(1,cutWin:end-cutWin);
hlow = Maximum_mean(base_c, 50, 'Type', 'percent', 'Dimension', 2);
base2_0 = base2_c;
base2_0(base2_c < 0) = 0;
h = Maximum_median(base2_0, 90, 'Type', 'percent', 'Dimension', 2);

dil = imdilate(base2_c, SE);
idx = find((dil - base2_c) == 0 & (base2_c > h) & (base_c < hlow));

starts = idx(base1_c(idx)>0);
stops = idx(base1_c(idx)<0);
starts = starts + cutWin-1;
stops = stops + cutWin-1+ceil(length(SE)/2);

[starts, stops] = reSeq(starts, stops);

%% refinement // search ofor the minimum value in the neighbourhood
starts = arrayfun(@(a) getMin1(a, 3, base), starts);
stops = arrayfun(@(a) getMin2(a, 3, base), stops);

[baseline] = curve_fitting(base, starts, stops);
end

function Fin = getMin1(idx,win,base)

if idx-win < 1
    win = idx-1;
end

segment = base(idx-win:idx);

[~,Fin] = min(segment);
Fin = idx-win+Fin-1;
end

function Fin = getMin2(idx,win,base)

if idx + win > length(base)
    win = length(base)-idx;
end

segment = base(idx:idx+win);

[~,Fin] = min(segment);
Fin = idx+Fin-1;
end

