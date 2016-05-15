
function [bigans] = general_se_vs_ard_singleround(N, D, trainsize, actualK) 
%N = 2200;
%D = 5;
%trainsize = 2000;
%actualK = 2;

noisevar = 0.05;
input = unifrnd(-10, 10, N, D);
output = [];

argsv.bigA = sampleONMatrix(actualK, D);
argsv.ell = 1.1
reducedinput = input * argsv.bigA';
output = sampleGP(reducedinput, argsv.ell);

[f1] = evaluation_se(input, output, N, trainsize)
[f2] = evaluation_se(reducedinput, output, N, trainsize)
[f3] = evaluation_ard(input, output, N, trainsize)
%[f4] = evaluation_ard(reducedinput, output, N, trainsize)

newans = zeros(4,4);

newans(:, 1) = f1;
newans(:, 2) = f2;
newans(:, 3) = f3;
newans(:, 4) = f2; % instead of f4..........
bigans = newans;
end
