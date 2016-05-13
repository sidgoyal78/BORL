function [finalans] =  evaluation_seadditive(input, output, N, trainsize)

finalans = zeros(4,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% for basic SE kernel
sgp1.inputs = input(1:trainsize, :);
sgp1.targets = output(1:trainsize);
op = [];
minval = [];
for i = 1:2
	[sgp1, sgp1_nlml] = train_seadditive(sgp1, 10, [400 400])
	if isempty(op)
		minval = sgp1_nlml;
		op = sgp1.hyp;
	else
		if minval > sgp1_nlml
			op = sgp1.hyp;
			minval = sgp1_nlml;	
		end
	end
	sgp1 = rmfield(sgp1, 'hyp');
end
covfunc = {'covSum', {'covSEdimadditive', 'covNoise'}};
sgp1.hyp = op;
sgp1_nlml = minval;

% getting prediction on test data
[predmu1, predsig1] = gpr(sgp1.hyp, covfunc, sgp1.inputs, sgp1.targets, input(trainsize+1:N, :));
% 	NLPP for test
[nlp1, mnlp1] = neg_log_predprob(predmu1, output(trainsize+1:N), predsig1);
%	MSE for test
[sms1, smse1] = std_mean_squared_error(predmu1, output(trainsize + 1 : N), predsig1);

% getting prediction on train data
[predtrain_mu1, predtrain_sig1] = gpr(sgp1.hyp, covfunc, sgp1.inputs, sgp1.targets, sgp1.inputs);
%	MSE for train
[tsms1, tsmse1] = std_mean_squared_error(predtrain_mu1, sgp1.targets, predtrain_sig1);

finalans(1) = sgp1_nlml;
finalans(2) = smse1;
finalans(3) = tsmse1;
finalans(4) = mnlp1;
clear K;
