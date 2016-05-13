% Basically train_mat_precompute with correct initialization, which should be provided in argsv.bigA
% 

function [gpmodel nlml] = train_mat_precompute_correctinit(gpmodel, dump, iter, lowdim, argsv)
%% Code

% 1) Initialization
if nargin < 3, iter = [-500 -1000]; end           % default training iterations

numD = size(gpmodel.inputs, 2) * lowdim  % here D = d * k 
E = size(gpmodel.targets,2);   % get variable sizes
covfunc = {'covSum', {'covSEmatprec', 'covNoise'}};        % specify ARD covariance
curb.snr = 1000; curb.ls = 100; curb.std = std(gpmodel.inputs);   % set hyp curb
if ~isfield(gpmodel,'hyp')  % if we don't pass in hyper-parameters, define them
  gpmodel.hyp = zeros(numD+2,E); nlml = zeros(1,E);
  % initializing the projmatrix parameters by randn(1, D);
  [okaybhi1, okaybhi2]  = size(argsv.bigA)
  aurnumD = numD
  correctinit = reshape(argsv.bigA, 1, numD)/argsv.ell;
  lh = repmat([correctinit 0 -1]',1,E);   % init hyp length scales
%  lh(numD + 1,:) = log(argsv.sigvar^0.5);
%  lh(numD + 2, :) = log(argsv.noisevar^0.5);

  %lh = repmat([ randn(1, numD) 0 -1]',1,E);   % init hyp length scales
  lh(numD+1,:) = log(std(gpmodel.targets)) ;                     %  signal std dev
  lh(numD+2,:) = log(std(gpmodel.targets)/10);                     % noise std dev

  
else
  lh = gpmodel.hyp                                    % GP hyper-parameters
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


