
addpath ../../gp_core/
addpath ../../kernels/
addpath ../../samplers/
addpath ../../train_gp_reg/

N = 1500;
trainsize = 1000;

actualK = -1; % will not matter

numrep = 3; % number of repetitions!!


D = 6;

start_redK = 1;
iter_redK  = 1;
end_redK = 4;

i = 1

[finalans] = repgeneral_2dimadditive(N, D, trainsize, actualK, numrep, i);



