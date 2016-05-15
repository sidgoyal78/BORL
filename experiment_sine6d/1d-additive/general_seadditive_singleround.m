
function [bigans] = general_seadditive_singleround(N, D, trainsize, actualK) 
%N = 2200;
%D = 5;
%trainsize = 2000;
%actualK = 2;

noisevar = 0.05;
input = unifrnd(-10, 10, N, D);
output = sin(input(:, 1)) + normrnd(0, noisevar, N, 1);

%argsv.bigA = sampleONMatrix(actualK, D);
%argsv.ell = 1.1
%reducedinput = input * argsv.bigA';
%output = sampleGP(reducedinput, argsv.ell);

[f1] = evaluation_seadditive(input, output, N, trainsize)
bigans = f1;
end
