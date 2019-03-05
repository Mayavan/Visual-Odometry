function E = findEssentialMatrix(matchedPoints1,matchedPoints2, K)

% Calculate fundamental matrices for multiple Iterations to get matrix
% calculated with inliers
error = 100;
len = length(matchedPoints1.Location);

for jj = 1:1000
    r = randi([1 len],1,8);
    
    inliers1 = matchedPoints1.Location(r,:);
    x_r = inliers1(:,1)';
    y_r = inliers1(:,2)';
    
    inliers2 = matchedPoints2.Location(r,:);
    x_l = inliers2(:,1)';
    y_l = inliers2(:,2)';
    
    % Matrix A is form with the 8 points from the equation x’TFx = 0
    A = [x_r(1) * x_l(1), x_r(1) * y_l(1), x_r(1), y_r(1) * x_l(1), y_r(1) * y_l(1), y_r(1), x_l(1), y_l(1), 1;
        x_r(2) * x_l(2), x_r(2) * y_l(2), x_r(2), y_r(2) * x_l(2), y_r(2) * y_l(2), y_r(2), x_l(2), y_l(2), 1;
        x_r(3) * x_l(3), x_r(3) * y_l(3), x_r(3), y_r(3) * x_l(3), y_r(3) * y_l(3), y_r(3), x_l(3), y_l(3), 1;
        x_r(4) * x_l(4), x_r(4) * y_l(4), x_r(4), y_r(4) * x_l(4), y_r(4) * y_l(4), y_r(4), x_l(4), y_l(4), 1;
        x_r(5) * x_l(5), x_r(5) * y_l(5), x_r(5), y_r(5) * x_l(5), y_r(5) * y_l(5), y_r(5), x_l(5), y_l(5), 1;
        x_r(6) * x_l(6), x_r(6) * y_l(6), x_r(6), y_r(6) * x_l(6), y_r(6) * y_l(6), y_r(6), x_l(6), y_l(6), 1;
        x_r(7) * x_l(7), x_r(7) * y_l(7), x_r(7), y_r(7) * x_l(7), y_r(7) * y_l(7), y_r(7), x_l(7), y_l(7), 1;
        x_r(8) * x_l(8), x_r(8) * y_l(8), x_r(8), y_r(8) * x_l(8), y_r(8) * y_l(8), y_r(8), x_l(8), y_l(8), 1];
    
  
    % Since in SVD, the 3rd matrix is a matrix of eigen vectors in the
    % order of increasing eigen values, the eigen vector for the smallest
    % eigen value is the last column in the V matrix
    [~, ~, V] = svd(A, 0);
    Ftemp = reshape(V(:, end), 3, 3)';
    
    % Convert Matrix to rank 2
    [U,D,V] = svd(Ftemp);
    D(3,3)=0;
    Ftemp=U*D*V';
    
    
    
    X_r=[inliers1(1,:), 1];
    X_l=[inliers2(1,:), 1];
    
    e = abs(X_r * Ftemp * X_l');
    
    if e < error
        error = e;
        F = Ftemp;
    end
end

% Calculating Essential matrix from fundamental Matrix
E = K' * F * K;

end

