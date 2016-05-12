%% train_ard.m
% *Summary:* Train a GP model with SE covariance function (ARD). First, the 
% hyper-parameters are trained using a full GP. Then, if gpmodel.induce exists, 
% indicating sparse approximation, if enough training exmples are present, 
% train the inducing inputs (hyper-parameters are taken from the full GP). 
% If no inducing inputs are present, then initialize thme to be a
% random subset of the training inputs.
%
%   function [gpmodel nlml] = train(gpmodel, dump, iter)
%
% *Input arguments:*
%
%   gpmodel                 GP structure
%     inputs                GP training inputs                      [ N  x  D]
%     targets               GP training targets                     [ N  x  E]
%     hyp (optional)        GP log-hyper-parameters                 [D+2 x  E]
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
% Modified the original code by  Marc Deisenroth, Andrew McHutchon, Joe Hall, and Carl Edward Rasmussen. (2013-05-16)
%
%% High-Level Steps
% # Initialization
% # Train full GP

function [gpmodel nlml] = train_ard(gpmodel, dump, iter)
%% Code

% 1) Initialization
if nargin < 3, iter = [-500 -1000]; end           % default training iterations

D = size(gpmodel.inputs,2); E = size(gpmodel.targets,2);   % get variable sizes
covfunc = {'covSum', {'covSEard', 'covNoise'}};        % specify ARD covariance
curb.snr = 1000; curb.ls = 100; curb.std = std(gpmodel.inputs);   % set hyp curb
if ~isfield(gpmodel,'hyp')  % if we don't pass in hyper-parameters, define them
  gpmodel.hyp = zeros(D+2,E); nlml = zeros(1,E);
  lh = repmat([log(std(gpmodel.inputs)) 0 -1]',1,E);   % init hyp length scales
  lh(D+1,:) = log(std(gpmodel.targets)) ;                     %  signal std dev
  lh(D+2,:) = log(std(gpmodel.targets)/10) ;                     % noise std dev
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


