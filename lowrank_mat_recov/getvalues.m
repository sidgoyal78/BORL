function y = getvalues(BIGM, XI, epsilon, funstring)

[d, mX, mPHI] = size(BIGM);
y = [];
fvals = [];
xfunc = str2func(funstring);
for i = 1:mX
    fvals = [fvals; xfunc(XI(:, i))];
end


% fvals is mX x 1 array

for i = 1:mPHI
    temp = 0;
    for j = 1:mX
        temp = temp +  xfunc(XI(:, j) + epsilon * BIGM(:, j, i))  -  fvals(j);
    end
    temp = temp / epsilon;
    y = [y; temp];
end

