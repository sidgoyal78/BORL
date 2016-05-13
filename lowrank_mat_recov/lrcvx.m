mPHI = 4; mX = 4; d = 4;
lambda = 50;
A = randn(mPHI, d * mX);
y = randn(mPHI, 1);

cvx_begin sdp
variable X(d, mX) 
variable W1(d, d)
variable W2(mX, mX)

X(1,1) == 3;
X(2,2) == 2;
X(3,3) == 1;
X(4,4) == 5;
X(1,2) == .5;
X(1,4) == .25;
X(2,3) == .75;
%a =[W1, X, zeros(d, d), zeros(d, mX); X', W2, zeros(mX, d), zeros(mX, mX); zeros(d, d), zeros(d, mX), lambda*eye(d), reshape(A'*(y - A*reshape(X, d * mX, 1)), d, mX) ; zeros(mX, d), zeros(mX, mX), reshape(A'*(y - A*reshape(X, d * mX, 1)), d, mX)', lambda * eye(mX)] >= 0
a = [W1, X; X', W2] 
a = 0.5 * (a + a')

minimize((trace(W1) + trace(W2)) / 2)
a >= 0
cvx_end


