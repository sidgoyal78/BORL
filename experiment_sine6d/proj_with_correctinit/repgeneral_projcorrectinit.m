
function [finalans] = repgeneral_projcorrectinit(N, D, trainsize, actualK, numrep, redK) 
%N = 2200;
%D = 5;

finalans = zeros(5, numrep);
for iter = 1:numrep
	bhainum = iter
	finalans(:, iter) = general_projcorrectinit_singleround(N, D, trainsize, actualK, redK);
end

meanval = zeros(5,1);
sigval = zeros(5,1);

for i = 1:5
		meanval(i) = mean(finalans(i,:));
		sigval(i) = std(finalans(i,:));
end

fil1 = strcat('k3_redk2/only_pi_projcompare_mean_D', int2str(D), '_K', int2str(actualK) , '.csv');
fil2 = strcat('k3_redk2/only_pi_projcompare_std_D', int2str(D), '_K', int2str(actualK) , '.csv');

csvwrite(fil1, meanval);
csvwrite(fil2, sigval);

