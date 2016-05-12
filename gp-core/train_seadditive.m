%% train_seadditive.m: for 1D-additive kernel
%

function [gpmodel nlml] = train_seadditive(gpmodel, dump, iter)
%% Code

% 1) Initialization
if nargin < 3, iter = [-500 -1000]; end           % default training iterations

D = size(gpmodel.inputs,2); E = size(gpmodel.targets,2);   % get variable sizes
covfunc = {'covSum', {'covSEdimadditive', 'covNoise'}};        % specify ARD covariance
curb.snr = 1000; curb.ls = 100; curb.std = std(gpmodel.inputs);   % set hyp curb
if ~isfield(gpmodel,'hyp')  % if we don't pass in hyper-parameters, define them
  gpmodel.hyp = zeros(2*D+1,E); nlml = zeros(1,E);

  sval_sigvar = log(std(gpmodel.targets));
  temp_arr = zeros(1, 2*D + 1);
  for i = 2:2:2*D
	temp_arr(i) = sval_sigvar;	
  end
  for i = 1:2:2*D
	temp_arr(i) = unifrnd(0.5, 1);	
  end
  lh = repmat(temp_arr',1,E);                   
  lh(2*D+1,:) = log(std(gpmodel.targets)/10) ;                  % noise std dev
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


