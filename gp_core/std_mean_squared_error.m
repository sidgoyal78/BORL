function [smse,mean_smse] = std_mean_squared_error(predictedy, actualy, variances)

    %smse = ((actualy - predictedy).^2)./variances;
    smse = ((actualy - predictedy).^2);

    mean_smse = mean(smse);

end