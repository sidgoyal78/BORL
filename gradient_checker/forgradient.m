function a = forgradient(func, hpsize, covfunc, a1, a2)

    num = 10;
    err = zeros(num,1);
    for i = 1:num
        hp = rand(hpsize, 1) * 3;
        err(i) = grad_check(func, hp, covfunc, a1, a2);
    end
    if mean(err) < 1e-6
        fprintf('Pass!\n');   
    else
        fprintf('Fail\n');
    end
    a = err
end