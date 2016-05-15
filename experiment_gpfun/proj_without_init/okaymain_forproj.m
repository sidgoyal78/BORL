

addpath ../../gp_core/
addpath ../../kernels/
addpath ../../samplers/
addpath ../../train_gp_reg/

N = 1500;
trainsize = 1000;
startD = 2;
iterD = 1;
endD = 5;

actualK = 3;

numrep = 8;

redK = 4; 

for i = startD:iterD:endD
	[finalans] = repgeneral_proj(N, i, trainsize, actualK, numrep, redK);
end

startD = 6;
iterD = 2;
endD = 10;
for i = startD:iterD:endD
	[finalans] = repgeneral_proj(N, i, trainsize, actualK, numrep, redK);
end





