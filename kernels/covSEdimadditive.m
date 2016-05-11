%% covSEdimadditive.m
% Additive SE kernel for all dimensions
%
% k(x^p,x^q) = sf2_1 * exp(-(x^p(1) - x^q(1))'*(x^p(1) - x^q(1))/(2*ell_1^2)) + sf2_2 * exp(-(x^p(2) - x^q(2))'*(x^p(2) - x^q(2))/(2*ell_1^2)) ....
%		sf2_D * exp(-(x^p(D) - x^q(D))'*(x^p(D) - x^q(D))/(2*ell_D^2))
%
% where individual lengthscales are ell_1^2,...,ell_D^2, where
% D is the dimension of the input space and sf2_1, sf2_2, ... sf2_D are the respective signal variances. The
% hyperparameters are:
%
% loghyper = [ log(ell_1)
%	       log(sqrt(sf2_1))
%	       log(ell_2)
%              log(sqrt(sf2_2))
%               .
%              log(ell_D)
%              log(sqrt(sf2_D)) ]
%
% Modified the original code which was by Carl Edward Rasmussen (2006-03-24)

function [A, B] = covSEdimadditive(loghyper, x, z)
%% Code
if nargin == 0, A = '(2*D)'; return; end          % report number of parameters

persistent K;    

[n, D] = size(x);

all_hyp = exp(2*loghyper);
all_ell_sq = all_hyp(1:2:(2*D));		% square of characteristic length scales for each dimension
all_sf2 = all_hyp(2:2:(2*D));		% signal variance for each dimension

tempmat = sq_dist(x');
fullsize = 2*D;

if nargin == 2
  %% to return the covariance matrix formed using training points x
  K = all_sf2(1) * exp(-tempmat / (2*all_ell_sq(1))); 
  for i = 2:D
  	K = K + all_sf2(i) * exp(-tempmat / (2*all_ell_sq(i)));
  end   	
  A = K;     

            
elseif nargout == 2                              % compute test set covariances
  A = sum(all_sf2)*ones(size(z,1),1);
  newtm = sq_dist(x', z');
  B = all_sf2(1) * exp(-newtm/(2 * all_ell_sq(1)));
  for i = 2:D
 	B = B + all_sf2(i) * exp(-newtm/(2 * all_ell_sq(i)));
  end  
  %B = sf2*exp(-sq_dist(diag(1./ell)*x',diag(1./ell)*z')/2);
else                                                % compute derivative matrix
  
  % Get the required index 
  index = -1;
  if mod(z, 2) == 1
  	index = floor(z/2) + 1;
  else
	index = z/2;
  end

  K = all_sf2(index) * exp(-tempmat / (2 * all_ell_sq(index)));
   
  if mod(z, 2) == 1                                           % length scale parameters
    A = K.*tempmat/all_ell_sq(index);  
  else                                                    % magnitude parameters
    A = 2*K;
    clear K;
  end
end

