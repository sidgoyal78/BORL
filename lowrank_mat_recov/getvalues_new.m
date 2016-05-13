function y = getvalues_new(BIGM, XI, epsilon, funstring, argsv)

[d, mX, mPHI] = size(BIGM);
y = [];
fvals = [];
xfunc = str2func(funstring);
for i = 1:mX
    fvals = [fvals; xfunc(XI(:, i), argsv)];
end


% fvals is mX x 1 array

for i = 1:mPHI
    temp = 0;
    for j = 1:mX
        temp = temp +  xfunc((XI(:, j) + epsilon * BIGM(:, j, i)), argsv)  -  fvals(j);
    end
    temp = temp / epsilon;
    y = [y; temp];
end

