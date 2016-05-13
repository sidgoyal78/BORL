
addpath ../../gp_core/
addpath ../../kernels/
addpath ../../samplers/
addpath ../../train_gp_reg/


N = 1500;
trainsize = 1000;

actualK = 3;

numrep = 4; % number of repetitions!!

redK = 2;

startD = 2;
iterD  = 2;
endD = 10;
for i = startD:iterD:endD
	dekho = i
	[finalans] = repgeneral_seadditive(N, i, trainsize, actualK, numrep, redK);
end



