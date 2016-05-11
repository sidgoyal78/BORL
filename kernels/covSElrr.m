function [A, B] = covSElrr(loghyper, x, z)
% Kernel for SE + proj type kernel, except that the projection matrix is first learnt by the 
% low rank matrix recovery algorithm, and then used as it is (via the global parameter: projectionMat)

if nargin == 0, A = '1'; return; end          % report number of parameters

persistent K;    

[n, D] = size(x);
%ell = exp(loghyper(1));                       % No length scale parameter
sf2 = exp(2*loghyper(1));                                   % signal variance
global projectionMat

if nargin == 2
  
  K = sf2*exp(-sq_dist(projectionMat * x')/2);
  A = K;                 

elseif nargout == 2                              % compute test set covariances
  A = sf2*ones(size(z,1),1);
  B = sf2*exp(-sq_dist(projectionMat*x',projectionMat*z')/2);

else                                                % compute derivative matrix
  
  %Kall = sq_dist(projectionMat*x');
  % check for correct dimension of the previously calculated kernel matrix
  if any(size(K)~=n)  
    %K = sf2*exp(-sq_dist( ((1/ell)*eye(D))*x')/2);
    K = sf2*exp(-sq_dist(projectionMat*x') / 2);
  end
                                                      
  A = 2*K;   % magnitude param
  clear K;
 
end

