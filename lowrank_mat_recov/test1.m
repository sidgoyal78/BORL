function y = test1(x)


d = size(x, 1); % dimensionality of the problem
avector = zeros(d, 1);
avector(1) = 1; % Only the first dimension is relevant, example 1: Tyagi and Cevher

inputforg = avector' * x;
opval = 1 / (1 + exp(-inputforg));
y = opval;

