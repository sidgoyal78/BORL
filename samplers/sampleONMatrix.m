% function for sampling a Orthonormal matrix of dimension d x D
function V = sampleONMatrix(d, D)

    M = randn(D, d);
    [Q, R] = qr(M, 0);
    V = Q';
    
end
