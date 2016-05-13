

rc.C2 = 2; rc.kappa1 = 0.4142;
k = 5; d = 10; mX = 20; mPHI =  500; fname = 'test2'; epsilon = 10^-3;

% Populating bigA, b and stddev in "argsv"
argsv.bigA = randn(k, d);
for i = 1:k
	argsv.bigA(i, :) = argsv.bigA(i, :) / norm(argsv.bigA(i,:));
end

scaleval= 0.2; % scaling for b
argsv.b = randn(k, 1);
argsv.b = argsv.b / norm(argsv.b);
argsv.b = scaleval * argsv.b;

argsv.stddev = unifrnd(0.1, 0.5, k, 1);

[approxM, anscheck] = recover_new(d, mX, mPHI, epsilon, fname, rc, k,argsv);
