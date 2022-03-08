function matrix = getArray(logVec, number)

siz1 = length(logVec);
%preallocate

matrix = zeros(number, siz1+number-1);

for n = 1:number
    matrix(n,n:siz1+n-1) = logVec;
end

end