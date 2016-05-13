

rc.C2 = 1; rc.kappa1 = 0.4142;
k = 5; d = 10; mX = 30; mPHI =  1500; fname = 'test3'; epsilon = 10^-1;

% Populating bigA, b and stddev in "argsv"
argsv.bigA = randn(k, d);
for i = 1:k
	argsv.bigA(i, :) = argsv.bigA(i, :) / norm(argsv.bigA(i,:));
end

scaleval= 1.0; % scaling for b, but no scaling for this example
argsv.b = randn(k, 1);
argsv.b = argsv.b / norm(argsv.b);
argsv.b = scaleval * argsv.b;

argsv.stddev = 0.01 / (d ^ 1.5);

ans = recover_new(d, mX, mPHI, epsilon, fname, rc, k,argsv);

accu = ans.check
actualA = ans.actA
estimateA = ans.estA'
