function approxM = recover(d, mX, mPHI, epsilon, functname, rc, k, argsv)

% rc is a structure containing required constants for computing lambda
% lambda = C2 * epsilon * mX * d * k * k * (1 + kappa1)^0.5 / (2 * (mPHI)^0.5)

lambda = rc.C2 * epsilon * mX * k^2 * (1 + rc.kappa1)^0.5 / (2 * (mPHI)^0.5)

[XI, BIGM, A] = sampleit(mPHI, mX, d); %generate input points
y = getvalues_new(BIGM, XI, epsilon, functname, argsv); %get point evaluations
%approxM = matrixDS_simple(d, mX, y, A, lambda)  % Using nuclear norm
Ahat = matrixDS(d, mX, y, A, lambda)  % Using the SDP formulation


% Now performing SVD
[U, S, V] = svd(Ahat);

% pick k columns
estA = U(:, 1:k);

% for the test function, actual is only first value as 1
%actualA = zeros(d, 1);
%actualA(1) = 1;

%check = abs(estA' * actualA)
approxM = estA;