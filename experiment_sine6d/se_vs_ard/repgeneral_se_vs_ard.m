
function [finalans] = repgeneral_se_vs_ard(N, D, trainsize, actualK, numrep) 
%N = 2200;
%D = 5;

finalans = zeros(4,4, numrep);
for iter = 1:numrep
	finalans(:,:,iter) = general_se_vs_ard_singleround(N, D, trainsize, actualK);
end

meanval = zeros(4,4);
sigval = zeros(4,4);

for i = 1:4
	for j = 1:4
		meanval(i,j) = mean(finalans(i,j,:));
		sigval(i,j) = std(finalans(i,j,:));
	end
end

fil1 = strcat('sine6d/bigcompare_mean_D', int2str(D), '_K', int2str(actualK) , '.csv');
fil2 = strcat('sine6d/bigcompare_std_D', int2str(D), '_K', int2str(actualK) , '.csv');

csvwrite(fil1, meanval);
csvwrite(fil2, sigval);
