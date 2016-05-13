function y = test4(x, argsv)

%bigA = argsv.bigA; 		% remember A is a k x d dimensional matrix (each row is d dimensional)
%b = argsv.b; 		    % b is a k x 1 vector

stddev = argsv.stddev; 	% stddev is a k x 1 vector

d = size(x, 1); % dimensionality of the problem

y = sin(x(1)) + normrnd(0, stddev);
