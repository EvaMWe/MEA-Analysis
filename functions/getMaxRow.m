% when preallocated cell exceeds maimum array size, this funtion calculates
% the maximum number of rows/samples dependent on number of electrodes.
% since the preallocation is a strong overestimation of sample number, this
% space is likely enough. Another funtion will check if each spike can be
% stored and will throw an error if not

function maxRow = getMaxRow(numbEl)

maxSamples = 134217728;

maxRow = floor(134217728/numbEl);

end