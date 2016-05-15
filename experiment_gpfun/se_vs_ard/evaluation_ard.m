function [finalans] =  evaluation_ard(input, output, N, trainsize)

finalans = zeros(4,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% for ARD kernel
mgp1.inputs = input(1:trainsize, :);
mgp1.targets = output(1:trainsize);
covfunc = {'covSum', {'covSEard', 'covNoise'}};

op = [];
minval = [];
for i = 1:2
	[mgp1, mgp1_nlml] = train_ard(mgp1, 10, [400 400])
	if isempty(op)
		minval = mgp1_nlml;
		op = mgp1.hyp;
	else
		if minval > mgp1_nlml
			op = mgp1.hyp;
			minval = mgp1_nlml;	
		end
	end
	mgp1 = rmfield(mgp1, 'hyp');
end
mgp1.hyp = op;
mgp1_nlml = minval;

bc = mgp1.hyp

% getting prediction on test data
[predmu2, predsig2] = gpr(mgp1.hyp, covfunc, mgp1.inputs, mgp1.targets, input(trainsize+1:N, :));
% 	NLPP for test
[nlp2, mnlp2] = neg_log_predprob(predmu2, output(trainsize+1:N), predsig2);
%	MSE for test
[sms2, smse2] = std_mean_squared_error(predmu2, output(trainsize + 1 : N), predsig2);

% getting prediction on train data
[predtrain_mu2, predtrain_sig2] = gpr(mgp1.hyp, covfunc, mgp1.inputs, mgp1.targets, mgp1.inputs);
%	MSE for train
[tsms2, tsmse2] = std_mean_squared_error(predtrain_mu2, mgp1.targets, predtrain_sig2);

finalans(1) = mgp1_nlml;
finalans(2) = smse2;
finalans(3) = tsmse2;
finalans(4) = mnlp2;

clearvars predmu2, nlp2, sms2, predtrain_mu2, tsms2, mgp1;
clear K;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
