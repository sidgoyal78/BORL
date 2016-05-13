
function [bigans] = general_2dimadditive_singleround(N, D, trainsize, actualK) 
%N = 2200;
%D = 5;
%trainsize = 2000;

addpath ../../samplers/


noisevar = 0.05;
input = unifrnd(-10, 10, N, D);
output = [];

argsv.bigA = sampleONMatrix(actualK, D);
argsv.ell = 1.1
reducedinput = input * argsv.bigA';
output = sampleGP(reducedinput, argsv.ell);

[f1] = evaluation_2dimadditive(input, output, N, trainsize)
bigans = f1;
end
