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
function J = dil_2D(TS, len)
tic
n_row = size(TS,1);
n_col = size(TS,2);
J_temp =zeros(n_row + len,n_col);
TS_temp = zeros( n_row + len,n_col);
TS_temp(len+1:end,:) = TS;


for idx = 1:n_row
    log = any(TS_temp(idx:idx+len,:));
    if sum(log) ~= 0
        J_temp(idx+len,log) = 1;
    end
end

J = J_temp(len+1:end,1);
toc
end