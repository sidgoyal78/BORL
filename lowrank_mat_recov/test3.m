function y = test3(x, argsv)

bigA = argsv.bigA; 		% remember A is a k x d dimensional matrix (each row is d dimensional)
b = argsv.b; 		    % b is a k x 1 vector
stddev = argsv.stddev; 	% stddev is a k x 1 vector

d = size(x, 1); % dimensionality of the problem
k = size(b, 1); % low dimensionality value


ans = bigA * x - b;
y = norm(ans)^2 + normrnd(0, stddev);

%for i = 1:k
%	tempval = bigA(i, :)*x + b(i);
%	fval = (1 / sqrt(2 * pi * stddev(i)^2 )) * exp( -(tempval + b(i)) / (2 * stddev(i)^2));
%	sumval = sumval + fval;	
%end
%y = sumval;

