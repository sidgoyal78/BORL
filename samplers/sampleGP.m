% function for sampling a GP, for given input design matrix (arg1) and given SE kernel length-scale (arg2)
% Note: signal_variance = 1, and noise_variance = 0.05

function v = sampleGP(X, ell)

    [n, D] = size(X);
    addit = ones(n, 1);
    noisevar = 0.05;
    K = exp(-sq_dist(X'/ell) / 2) + diag(noisevar * addit);
    L = chol(K, 'lower');
    u = randn(n , 1);
    v = L * u;
    
end
