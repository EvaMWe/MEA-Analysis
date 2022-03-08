function timepoints = getTimepoints_GUI(varargin)

if nargin ~= 0
    sheetname = varargin{1,1};
    if ~isnan(str2double(sheetname))
        sheetname =str2double(sheetname);
    end
else 
    sheetname = 1;
end

[baseInfo, basePath] = uigetfile('*.xlsx','select file to determine time bins');
if ~iscell(baseInfo)
    baseInfo = cellstr(baseInfo);
end
filename = fullfile(basePath,baseInfo{1});
opts = detectImportOptions(filename);

opts.Sheet = sheetname;
opts.VariableNames = {'starts', 'stops'};
opts.DataRange = 'A3';
timepoints = readtable(filename,opts);
timepoints =table2array(timepoints);
if iscell(timepoints)
    if ischar(timepoints{1,1})
        timepoints = str2double(timepoints);
    end
end
 
                             

end

