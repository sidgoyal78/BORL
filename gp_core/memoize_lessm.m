function [M] = memoize_lessm(X, n, D);
% Function for calculating the feature-vector-difference matrix
% for speeding up gradient computation for the Projection kernel
	
precompA = zeros(n^2, D);

count = 0;
for i = 1:n
	for j = 1:n	
		count = count + 1;
		if i == j
			continue;
		end
		precompA(count, :) = X(i, :) - X(j, :);
	end
end
		
M = precompA;
