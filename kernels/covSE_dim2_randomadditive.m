%% covSE_dim2_additive.m
% Additive pairwise SE kernel,
%
% k(x^p,x^q) = sf2_1 * exp(-(x^p_(1,2) - x^q_(1,2))'*(x^p_(1,2) - x^q_(1,2))/(2*ell_1^2)) + 
%        	sf2_2 * exp(-(x^p_(3,4) - x^q_(3,4))'*(x^p_(3,4) - x^q_(3,4))/(2*ell_2^2)) ....
%		sf2_D * exp(-(x^p_D - x^q_D)'*(x^p_D - x^q_D)/(2*ell_(D/2)^2))
%
% where, there are D/2  individual lengthscales are ell_1^2,...
% D is the dimension of the input space and sf2_1, sf2_2, ... sf2_(D/2) are the respective signal variances. The
% hyperparameters are:
%
% loghyper = [ log(ell_1)
%	       log(sqrt(sf2_1))
%	       log(ell_2)
%              log(sqrt(sf2_2))
%               .
%              log(ell_D/2)
%              log(sqrt(sf2_D/2)) ]
%
%	Assumption: D is divisible by 2 TODO: if D % 2 == 1: then a SE kernel for the last dim has to be added
%
% The ordering of the individual features is governed by the global parameter: col_reordering
% Modified the original code by Carl Edward Rasmussen (2006-03-24)

function [A, B] = covSE_dim2_randomadditive(loghyper, x, z)
%% Code
if nargin == 0, A = 'D'; return; end          % report number of parameters

global col_reordering;
persistent K;    

x = x(:, col_reordering);
[n, D] = size(x);


all_hyp = exp(2*loghyper);

% Note the number of hyper-parameters are D (D/2 kernels each having 2 params)
all_ell_sq = all_hyp(1:2:D);		% square of characteristic length scales for each dimension
all_sf2 = all_hyp(2:2:D);		% signal variance for each dimension

%tempmat = sq_dist(x');

d = floor(D/2);

if nargin == 2
  %% to return the covariance matrix formed using training points x
  K = all_sf2(1) * exp(-sq_dist(x(:, 1:2)') / (2*all_ell_sq(1))); 
  for i = 2:d
  	K = K + all_sf2(i) * exp(-sq_dist(x(:,(2*i - 1):(2*i))') / (2*all_ell_sq(i)));
  end   	
  A = K;     

            
elseif nargout == 2                              % compute test set covariances
  z = z(:, col_reordering);
  A = sum(all_sf2)*ones(size(z,1),1);
%  newtm = sq_dist(x', z');
  B = all_sf2(1) * exp(- sq_dist(x(:, 1:2)', z(:, 1:2)')/(2 * all_ell_sq(1)));
  for i = 2:d
 	B = B + all_sf2(i) * exp(- sq_dist(x(:, (2*i - 1):(2*i))', z(:, (2*i - 1):(2 * i))')/(2 * all_ell_sq(i)));
  end  
  %B = sf2*exp(-sq_dist(diag(1./ell)*x',diag(1./ell)*z')/2);
else                                                % compute derivative matrix

  index = -1;
  if mod(z, 2) == 1
        index = floor(z/2) + 1;
  else
        index = z/2;
  end 

  pindex = 2*index - 1; 
  qindex = 2*index;

  tempmat = sq_dist(x(:, pindex:qindex)');
  K = all_sf2(index) * exp(- tempmat / (2 * all_ell_sq(index)));
   
  if mod(z, 2) == 1                                           % length scale parameters
    A = K.*tempmat/all_ell_sq(index);  
  else                                                    % magnitude parameters
    A = 2*K;
    clear K;
  end
end

