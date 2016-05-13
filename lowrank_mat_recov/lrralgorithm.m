
function [approxA, simil, mX, mPHI] = lrralgorithm(k, d, fname, epsilon, argsv)
rc.C2 = 2; rc.kappa1 = 0.4142;
p = 0.01;
alpha = 1;

%k = 10; d = 10;

mX = ceil(2 * k * rc.C2^2 * log(k / p) / alpha);
mPHI = 4 * k * (d + mX + 1) ;

%fname = 'test1_new'; 
%epsilon = 10^-3;

[approxA, simil] = recover_new(d, mX, mPHI, epsilon, fname, rc, k,argsv);

end
