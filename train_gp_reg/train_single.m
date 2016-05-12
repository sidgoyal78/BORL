%% train_single.m
%
%   function [gpmodel nlml] = train_single(gpmodel, dump, iter)
%
% *Input arguments:*
%
%   gpmodel                 GP structure
%     inputs                GP training inputs                      [ N  x  D]
%     targets               GP training targets                     [ N  x  E]
%     hyp (optional)        GP log-hyper-parameters                 [1+2 x  E]
%   dump                    not needed for this code, but required
%                           for compatibility reasons
%   iter                    optimization iterations for training    [1   x  2]
%                           [full GP, sparse GP]
%
% *Output arguments:*
%
%   gpmodel                 updated GP structure
%   nlml                    negative log-marginal likelihood
%
%
%% High-Level Steps
% # Initialization
% # Train full GP
% modified code from PICOv0.9 (which is written by Marc Deisenroth and Prof Rasmussen)

function [gpmodel nlml] = train_single(gpmodel, dump, iter)
%% Code

% 1) Initialization
if nargin < 3, iter = [-500 -1000]; end           % default training iterations

D = 1; E = size(gpmodel.targets,2);   % get variable sizes
covfunc = {'covSum', {'covSEsingle', 'covNoise'}};        % specify ARD covariance
curb.snr = 1000; curb.ls = 100; curb.std = std(gpmodel.inputs);   % set hyp curb
if ~isfield(gpmodel,'hyp')  % if we don't pass in hyper-parameters, define them
  gpmodel.hyp = zeros(D+2,E); nlml = zeros(1,E);
  lh = repmat([log(0.5) 0 -1]',1,E);                     % init hyp length scales
  lh(D+1,:) = log(std(gpmodel.targets)) ;                     %  signal std dev
  lh(D+2,:) = log(std(gpmodel.targets)/10) ;                  % noise std dev
else
  lh = gpmodel.hyp;                                       % GP hyper-parameters
end

% 2a) Train full GP (always)

fprintf('Train hyper-parameters of full GP ...\n');

for i = 1:E                                          % train each GP separately
  fprintf('GP %i/%i\n', i, E);
  try   % BFGS training
    [gpmodel.hyp(:,i) v] = minimize_gp(lh(:,i), @hypCurb, iter(1), covfunc, ...
      gpmodel.inputs, gpmodel.targets(:,i), curb);
  catch % conjugate gradients (BFGS can be quite aggressive)
    [gpmodel.hyp(:,i) v] = minimize_gp(lh(:,i), @hypCurb, ...
      struct('length', iter(1), 'method', 'CG', 'verbosity', 1), covfunc, ...
      gpmodel.inputs, gpmodel.targets(:,i), curb);
   
  end
  nlml(i) = v(end);
end


