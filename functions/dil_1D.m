% function to dilate a binary vector (for example containing time stamps of
% a channel;
% vec: is the vector that has to be dilated
% len: is the lenght of the linear structuring element; since this function
% operates in 1-D also len hat just one dimension
% J is replaced from the first element on:
% first element J1 is the max within the structuring element including
% vec_1:vec_len; the second J2 is the max within vec_2:vec_len+1...and so
% on;

%
function J = dil_1D(vec, len)

n = length(vec);
J_temp =zeros(n + len,1);
vec_temp = zeros( n + len,1);
vec_temp(len+1:end,1) = vec;

for idx = 1:n
    if any(vec_temp(idx:idx+len))
    J_temp(idx+len,1) = 1;
   end
end

J = J_temp(len+1:end,1);
end