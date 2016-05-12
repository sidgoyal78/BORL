N = 200;
D = 5;
covfunc = {'covSum', {'covSEdimadditive', 'covNoise'}}; % kernel to check
input = unifrnd(-5, 5, N, D);
output = sin(input(:, 1)) + normrnd(0, 0.05, N, 1);
nhp = 2 * D + 1;  % for additive kernel
a = forgradient(@gpr, nhp, covfunc, input, output);
