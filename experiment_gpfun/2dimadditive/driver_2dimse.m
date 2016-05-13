
addpath ../../gp_core/
addpath ../../kernels/
addpath ../../samplers/
addpath ../../train_gp_reg/

N = 1500;
trainsize = 1000;

actualK = 3;

numrep = 3;

redK = 2; % giving exact subspace size

startD = 2;
iterD  = 2;
endD = 10;
for i = startD:iterD:endD
	dekho = i
	[finalans] = repgeneral_2dimadditive(N, i, trainsize, actualK, numrep, redK);
end



