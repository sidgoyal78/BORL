
function [bigans] = general_proj_singleround(N, D, trainsize, actualK, redK) 
%N = 2200;
%D = 5;
%trainsize = 2000;
%actualK = 2;

noisevar = 0.05;
input = unifrnd(-10, 10, N, D);
output = sin(input(:, 1)) + normrnd(0, noisevar, N, 1);

%argsv.bigA = sampleONMatrix(actualK, D);
%argsv.ell = 1.1;

%reducedinput = input * argsv.bigA';
%output = sampleGP(reducedinput, argsv.ell);
argsv.bigA = unifrnd(-1, 1, redK, D); % this is just for time pass (un-necesarry hai yeh)

[f1] = neweval_projkernel(D, input, output, N, trainsize, redK, argsv);
bigans = f1;
end
