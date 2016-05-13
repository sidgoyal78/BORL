function [nlpp, mean_nlpp] = neg_log_predprob(predictedy, actualy, variances)

    d = size(actualy, 1);
    output = [];
    for i = 1:d
        val = 0.5 * log(2*pi*variances(i)) + (predictedy(i) - actualy(i))^2/(2*variances(i));
        output = [output; val];
    end

    nlpp = output;
    mean_nlpp = mean(nlpp);
end