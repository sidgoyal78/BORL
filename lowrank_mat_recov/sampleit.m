function [XI, BIGM, A] = sampleit(mPHI, mX, d)

% XI is [d x mX] matrix: sampling centers
% BIGM is [d x mX x mPHI] matrix: directions
% A is [mPHI x d.mX] operator matrix, formed by stacking togther entries in BIGM
%
% The columns in XI matrix are sampled from S^(d - 1) using Marsaglia's method:
%    - first pick d gaussian samples [ N(0, 1) ]
%    - normalize it
% Each entry in BIGM matrix is +/- ( 1 / sqrt(mPHI) ) [REF: 3.7 in Tyagi and Cevher, low-rank recovery A.C.H.A. paper]
%

XI = randn(d, mX);
for i = 1:mX
	XI(:, i) = XI(:, i) / norm(XI(:, i));
end


BIGM = zeros(d, mX, mPHI);
val = 1 / sqrt(mPHI);

for i = 1:mPHI
    for j = 1:mX
        for k = 1:d
            if rand() > 0.5
                BIGM(k, j, i) = val;
            else
                BIGM(k, j, i) = -val;
            end
        end
    end
end

A = zeros(mPHI, d * mX);
for i = 1:mPHI
    A(i, :) = reshape(BIGM(:,:,i), 1, d*mX);
end


