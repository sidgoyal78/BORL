
addpath ../../gp_core/
addpath ../../kernels/
addpath ../../samplers/
addpath ../../train_gp_reg/


N = 1500;
trainsize = 1000;
startD = 2;
iterD = 2;
endD = 10;

actualK = 3;

numrep = 5;

for i = startD:iterD:endD
	[finalans] = repgeneral_se_vs_ard(N, i, trainsize, actualK, numrep)
end
