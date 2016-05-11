function [A, B] = covSEsingle(loghyper, x, z)
% Kernel for squared expontial kernel with 
% 	2 parameters: signal variance and characteristic length-scale

if nargin == 0, A = '(1 + 1)'; return; end          % report number of parameters

persistent K;    

[n, D] = size(x);
ell = exp(loghyper(1));                         % characteristic length scale
sf2 = exp(2*loghyper(2));                                   % signal variance

if nargin == 2
  %K = sf2*exp(-sq_dist(((1/ell)*eye(D))*x')/2);
  K = sf2*exp(-sq_dist(x'/ell)/2);
  A = K;                 

elseif nargout == 2                              % compute test set covariances
  A = sf2*ones(size(z,1),1);
  B = sf2*exp(-sq_dist(x'/ell,z'/ell)/2);

else                                                % compute derivative matrix
  
  Kall = sq_dist(x'/ell);
  % check for correct dimension of the previously calculated kernel matrix
  if any(size(K)~=n)  
    %K = sf2*exp(-sq_dist( ((1/ell)*eye(D))*x')/2);
    K = sf2*exp(-sq_dist(x'/ell) / 2);
  end
   
  if z <= 1                                           % length scale parameter
    A = K.*Kall;  
  else                                                    % magnitude parameter
     
    A = 2*K;
    clear K;
  end
end

