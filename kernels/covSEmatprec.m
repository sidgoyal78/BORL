%% covSEmat.m
% 
% newK(x^p,x^q) = k(A * x^p, A * x^q) =  sf2 * exp(-(x^p - x^q)'* A' * A* (x^p - x^q)/2)
% Note: A is k x d matrix
% 
% loghyper = [ A_11
%              A_12
%               .
%              A_kd
%              log(sqrt(sf2)) ]
%
% For more help on design of covariance functions, try "help covFunctions".
%
% Modified the original code which was written by Carl Edward Rasmussen (2006-03-24)
%
%
% NOTE: It uses a global parameter "precomputed", which basically stores the pairwise diffference of input feature vectors: 
%	This is done for a potentially faster gradient computation


function [A, B] = covSEmatprec(hyper, x, z)
%% Code
if nargin == 0, A = '(D * reducedim + 1)'; return; end          % report number of parameters


persistent K;    

[n, D] = size(x);
numhp = size(hyper, 1);
reqd = numhp - 1;				% the other hyperparameter is for signal variance

k = reqd / D;  					      % reduced dimension
sf2 = exp(2*hyper(reqd + 1));                                   % signal variance

projM = reshape(hyper(1:reqd), k, D);

%K = sf2*exp(-sq_dist(projM*x')/2);


if nargin == 2
  K = sf2*exp(-sq_dist(projM*x')/2);
  A = K;                 
elseif nargout == 2                              % compute test set covariances 
  A = sf2*ones(size(z,1),1);
  B = sf2*exp(-sq_dist(projM*x',projM*z')/2);
else                                                % compute derivative matrix
  
   %rowval = 1 + floor((z - 1)/ D);
   %colval = mod(z - 1, D) + 1;
   
   rowval = mod(z - 1, k) + 1;
   colval = 1 + floor((z - 1) / k);
   
  % check for correct dimension of the previously calculated kernel matrix
  if any(size(K)~=n)  
    K = sf2*exp(-sq_dist(projM * x')/2);
  end
   
  if z <=  reqd                                          % matrix parameters
    global precomputed;
    %temp = reshape( precomputed(:, :, colval) * projM(rowval, :)', n ,n);
    temp = reshape( (precomputed * projM(rowval, :)') .* precomputed(:, colval), n ,n);

%    for i = 1:n
%        for j = (i + 1):n
%            vect1 = x(i, :)';
%            vect2 = x(j, :)';
%            zv = vect1 - vect2;
%	    answerval = -1 * (projM(rowval, :) * zv) * zv(colval);
%            temp(i, j) = answerval;
%	    temp(j, i) = answerval;
%        end
%    end

    A = -K.* temp ;  
  else                                                    % signal variance magnitude parameter
    A = 2*K ;
    clear K;
  end
end

