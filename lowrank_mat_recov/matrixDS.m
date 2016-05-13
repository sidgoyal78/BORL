function X = matrixDS(d, mX, y, A, lambda)

cvx_begin sdp
variable X(d, mX)
variable W1(d, d)
variable W2(mX, mX)
a = [W1, X, zeros(d, d), zeros(d, mX); X', W2, zeros(mX, d), zeros(mX, mX); zeros(d, d), zeros(d, mX), lambda*eye(d), reshape(A'*(y - A*reshape(X, d * mX, 1)), d, mX) ; zeros(mX, d), zeros(mX, mX), reshape(A'*(y - A*reshape(X, d * mX, 1)), d, mX)', lambda * eye(mX)]
a = 0.5 * (a + a')
minimize((trace(W1) + trace(W2)) / 2)
%[W1, X, zeros(d, d), zeros(d, mX); X', W2, zeros(mX, d), zeros(mX, mX); zeros(d, d), zeros(d, mX), lambda*eye(d), reshape(A'*(y - A*reshape(X, d * mX, 1)), d, mX) ; zeros(mX, d), zeros(mX, mX), reshape(A'*(y - A*reshape(X, d * mX, 1)), d, mX)', lambda * eye(mX)] >= 0
a >= 0
cvx_end

