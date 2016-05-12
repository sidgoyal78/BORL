% For pair-wise additive kernel 

function [gpmodel nlml] = train_2dim_additive(gpmodel, dump, iter)
%% Code

% 1) Initialization
if nargin < 3, iter = [-500 -1000]; end           % default training iterations

D = size(gpmodel.inputs,2); E = size(gpmodel.targets,2);   % get variable sizes
covfunc = {'covSum', {'covSE_dim2_randomadditive', 'covNoise'}};        % specify ARD covariance
curb.snr = 1000; curb.ls = 100; curb.std = std(gpmodel.inputs);   % set hyp curb
if ~isfield(gpmodel,'hyp')  % if we don't pass in hyper-parameters, define them
  gpmodel.hyp = zeros(D+1,E); nlml = zeros(1,E);

  sval_sigvar = log(std(gpmodel.targets));
  temp_arr = zeros(1, D + 1);
  for i = 2:2:D
	temp_arr(i) = sval_sigvar;	
  end
  for i = 1:2:D
	temp_arr(i) = unifrnd(0.5, 1);	
  end
  lh = repmat(temp_arr',1,E);                   
  lh(D+1,:) = log(std(gpmodel.targets)/10) ;                  % noise std dev
else
  lh = gpmodel.hyp;                                       % GP hyper-parameters
end

% 2a) Train full GP (always)

fprintf('Train hyper-parameters of full GP ...\n');

global col_reordering;
%for i = 1:E                                          % train each GP separately
% Anyway we don't have many episodes, so to generate random orderings we loop over D times

hplist = [];
nlmlist = [];
niter = floor(D/2);
for i = 1:niter
  col_reordering = randperm(D);

  try   % BFGS training
    [hp v] = minimize_gp(lh, @hypCurb, iter(1), covfunc, ...
      gpmodel.inputs, gpmodel.targets, curb);
  catch % conjugate gradients (BFGS can be quite aggressive)
    [hp v] = minimize_gp(lh, @hypCurb, ...
      struct('length', iter(1), 'method', 'CG', 'verbosity', 1), covfunc, ...
      gpmodel.inputs, gpmodel.targets, curb);
  end
   hplist = [hplist; hp'];
   nlmlist = [nlmlist; v(end)];
end

see1 = hplist
see2 = nlmlist
[minval, minind] = min(nlmlist);
gpmodel.hyp = hplist(minind, :)';
nlml = minval;

