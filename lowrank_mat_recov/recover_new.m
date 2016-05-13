function [approxM, anscheck] = recover_new(d, mX, mPHI, epsilon, functname, rc, k,argsv)

% rc is a structure containing required constants for computing lambda
% lambda = C2 * epsilon * mX * d * k * k * (1 + kappa1)^0.5 / (2 * (mPHI)^0.5)

lambda = rc.C2 * epsilon * mX * k^2 * (1 + rc.kappa1)^0.5 / (2 * (mPHI)^0.5);

[XI, BIGM, A] = sampleit(mPHI, mX, d);                                %generate input points
y = getvalues_new(BIGM, XI, epsilon, functname, argsv);               %get point evaluations
Ahat = matrixDS(d, mX, y, A, lambda)                                  % Using the SDP formulation


% Now performing SVD
[U, S, V] = svd(Ahat);

% pick k columns
estA = U(:, 1:k);
actA = argsv.bigA;


anscheck = (1 / k) * (norm(actA * estA, 'fro') ^ 2);
approxM = estA';
