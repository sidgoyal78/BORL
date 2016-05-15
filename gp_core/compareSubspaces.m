function y = compareSubspaces(A1, A2)

    [U1, S1, V1] = svd(A1);
    [U2, S2, V2] = svd(A2);
    
    m = rank(A1);
    n = max(size(A1));
    
    y = norm(U1(:, 1:m)' * U2(:,m+1:n));
    
    x = norm(U1(:, 1:m)*U1(:, 1:m)' - U2(:, 1:m)*U2(:, 1:m)')

end
