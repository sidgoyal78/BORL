

rc.C2 = 2; rc.kappa1 = 0.4142;
extra1 = 5;
k = 1; d = 10; mX = ceil(extra1 * k * log(k) * 0.5); 
mPHI = k * (d + mX); 
fname = 'test1_new'; epsilon = 10^-3;

argsv.bigA = zeros(k, d);
argsv.bigA(1,1) = 1;

ans = recover_new(d, mX, mPHI, epsilon, fname, rc, k,argsv);

accu = ans.check
actualA = ans.actA
estimateA = ans.estA'
