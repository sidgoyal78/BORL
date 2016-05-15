
function [finalans] = repgeneral_seadditive(N, D, trainsize, actualK, numrep, redK) 
%N = 2200;
%D = 5;

finalans = zeros(4, numrep);
for iter = 1:numrep
	bhainum = iter
	finalans(:, iter) = general_seadditive_singleround(N, D, trainsize, actualK);
end

meanval = zeros(4,1);
sigval = zeros(4,1);

for i = 1:4
		meanval(i) = mean(finalans(i,:));
		sigval(i) = std(finalans(i,:));
end

fil1 = strcat('sine6d/additivese_mean_D', int2str(D), '_K', int2str(actualK) , '.csv');
fil2 = strcat('sine6d/additivese_std_D', int2str(D), '_K', int2str(actualK) , '.csv');

csvwrite(fil1, meanval);
csvwrite(fil2, sigval);

