rc.C2 = 2; rc.kappa1 = 0.4142;
epsilon = 10^-3;
k = 1; d = 10; mX = 20; mPHI = 500; fname = 'test1_new';

argsv.bigA = zeros(k, d);
argsv.bigA(1,1) = 1;

[Mat, anscheck] = recover_new(d, mX, mPHI, epsilon, fname, rc, k, argsv)
