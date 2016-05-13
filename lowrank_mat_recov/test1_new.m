function y = test1_new(x, args)


d = size(x, 1); % dimensionality of the problem
avector = zeros(d, 1);
avector(1) = 1; % Only the first dimension is relevant, example 1: Tyagi and Cevher

inputforg = avector' * x;
opval = 1 / (1 + exp(-inputforg));
y = opval + normrnd(0, 0.05);
