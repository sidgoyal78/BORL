
addpath ../../gp_core/
addpath ../../kernels/
addpath ../../samplers/
addpath ../../train_gp_reg/



N = 15;
trainsize = 10;

actualK = 3;

numrep = 1;

redK = 2; 

startD = 2;
iterD  = 2;
endD = 10;
for i = startD:iterD:endD
	[finalans] = repgeneral_projcorrectinit(N, i, trainsize, actualK, numrep, redK);
end



