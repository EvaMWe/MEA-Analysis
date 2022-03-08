% function to dilate a binary vector (for example containing time stamps of
% a channel;
% vec: is the vector that has to be dilated
% len: is the lenght of the linear structuring element; since this function
% operates in 1-D also len hat just one dimension


%
function J = dil_1D_centered(vec, len)
if mod(len,2) ~= 0
   len = len+1;
end
n = length(vec);
J_temp =zeros(n + len,1);
vec_temp = zeros(n + len,1);
dT = len/2;
vec_temp(dT+1:end-dT,1) = vec;


for idx = dT+1:n
    if any(vec_temp(idx-dT:idx+dT))
        J_temp(idx,1) = 1;
    end
end

J = J_temp(dT+1:end-dT,1);
end