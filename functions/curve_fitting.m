function [base_fit] = curve_fitting(base, start, stop)
%fit between two curve segments

fitting_window = 2;
burst_number =length(start);
lenTail = 5;

start_x = start;
end_x = stop;
%if burst stop is missing
if length(start_x) > length(end_x)
    end_x = [end_x start_x(end)];
end
%fitting_window = base_cal.winsmall;
pad= 2*fitting_window+2;
tail = repmat(base(end),1,lenTail);
data = [base tail];
degree = 1;

x = zeros(burst_number, pad);
y = zeros(burst_number, pad);
for burst = 1:burst_number
    x_temp = [start_x(burst)-fitting_window:start_x(burst) end_x(burst):end_x(burst)+fitting_window];
    if ~isempty(x_temp(x_temp <= 0))
        continue
    end
    if x_temp(end) >= length(data)
       continue
    end
    x(burst,1:pad) = x_temp;
    y(burst,1:pad) = data(x_temp);
end

base_fit = data;
for burst = 1:burst_number
    [p, S, mu] = polyfit(x(burst,:),y(burst,:),degree);
    x_place = start_x(burst) : end_x(burst);
    y_place = polyval(p,x_place, S, mu);
    base_fit(x_place) = y_place;
end
base_fit = base_fit(1,1:length(base_fit)-lenTail);
end

