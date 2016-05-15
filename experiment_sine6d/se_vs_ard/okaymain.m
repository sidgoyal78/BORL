
addpath ../../gp_core/
addpath ../../kernels/
addpath ../../samplers/
addpath ../../train_gp_reg/


N = 1500;
trainsize = 1000;


actualK = -1; % will not matter

numrep = 6; % number of repetitions!!


D = 6;


[finalans] = repgeneral_se_vs_ard(N, D, trainsize, actualK, numrep)
