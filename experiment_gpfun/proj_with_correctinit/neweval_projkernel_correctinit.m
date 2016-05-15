function [finalans] =  neweval_projkernel_correctinit(D, input, output, N, trainsize, k, argsv)

finalans = zeros(5,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% for projection matrix kernel
mgp2.inputs = input(1:trainsize, :);
mgp2.targets = output(1:trainsize);
global precomputed;
precomputed = memoize_lessm(mgp2.inputs, trainsize, D);
covfunc = {'covSum', {'covSEmatprec', 'covNoise'}};   % Using the covSEmatprec.m version (with memoization) 

op = [];
minval = [];
for i = 1:1
	[mgp2, mgp2_nlml] = train_mat_precompute_correctinit(mgp2, 10, [400 400], k, argsv)
	if isempty(op)
		minval = mgp2_nlml;
		op = mgp2.hyp;
	else
		if minval > mgp2_nlml
			op = mgp2.hyp;
			minval = mgp2_nlml;	
		end
	end
	mgp2 = rmfield(mgp2, 'hyp');
end
mgp2.hyp = op;
mgp2_nlml = minval;


% getting prediction on test data
[predmu3, predsig3] = gpr(mgp2.hyp, covfunc, mgp2.inputs, mgp2.targets, input(trainsize+1:N, :));
% 	NLPP for test
[nlp3, mnlp3] = neg_log_predprob(predmu3, output(trainsize+1:N), predsig3);
%	MSE for test
[sms3, smse3] = std_mean_squared_error(predmu3, output(trainsize + 1 : N), predsig3);

% getting prediction on train data
[predtrain_mu3, predtrain_sig3] = gpr(mgp2.hyp, covfunc, mgp2.inputs, mgp2.targets, mgp2.inputs);
%	MSE for train
[tsms3, tsmse3] = std_mean_squared_error(predtrain_mu3, mgp2.targets, predtrain_sig3);

finalans(1) = mgp2_nlml;
finalans(2) = smse3;
finalans(3) = tsmse3;
finalans(4) = mnlp3;

dekhasli = argsv.bigA
projkmat = reshape(mgp2.hyp(1:k*D), k, D)/argsv.ell
%if flag == true [IN THIS EXPERIMENT WE GUARANTEE]
        checkproj = compareSubspaces(argsv.bigA', projkmat');
        finalans(5) = checkproj;
%end

%clear precomputed;
%clear K;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
