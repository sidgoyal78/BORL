

addpath ../../gp_core/
addpath ../../kernels/
addpath ../../samplers/
addpath ../../train_gp_reg/

N = 1500;
trainsize = 1000;

D = 6;
actualK = -1; %does not matter

numrep =  6;

start_redK = 1; 
end_redK = 3;
iter_redK = 1;

for i = start_redK:iter_redK:end_redK
	[finalans] = repgeneral_proj(N, D, trainsize, actualK, numrep, i);
end






