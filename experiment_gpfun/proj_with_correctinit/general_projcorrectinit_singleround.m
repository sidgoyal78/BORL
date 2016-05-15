
function [bigans] = general_projcorrectinit_singleround(N, D, trainsize, actualK, redK) 
%N = 2200;
%D = 5;
%trainsize = 2000;
%actualK = 2;

noisevar = 0.05;
input = unifrnd(-10, 10, N, D);
output = [];

argsv.bigA = sampleONMatrix(actualK, D);
argsv.sigvar = 1.0;
argsv.noisevar = 0.05;
argsv.ell = 1.1;

reducedinput = input * argsv.bigA';
output = sampleGP(reducedinput, argsv.ell);

[f1] = neweval_projkernel_correctinit(D, input, output, N, trainsize, redK, argsv);
bigans = f1;
end
