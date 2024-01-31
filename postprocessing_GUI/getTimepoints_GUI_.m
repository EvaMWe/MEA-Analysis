%function to get time points from excel sheet without uigetfile
function timepoints = getTimepoints_GUI_(filename,varargin)

if nargin ~= 0
    sheetname = varargin{1,1};
    if ~isnan(str2double(sheetname))
        sheetname =str2double(sheetname);
    end
else 
    sheetname = 1;
end

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

