function [ ] =svr_intial(  )
    load housing_train.mat 'housing_train';
    global x
    global y
    global C
    global target
    global epsilon
    global tolerance
    global error_cache
    global c
    global sigma2
    global K
    global row
    global alpha
    global b
%    housing_train = housing_train(1:100,:);
    [row , col] = size(housing_train);
    y = housing_train(: , col);
    y = [y ; y];
    x = housing_train(: , 1:col - 1);
    x = [x ; x];
%     x = normlize( x );
    alpha = zeros(2 * row , 1);
    C = 5;
    target = [1 * ones(row , 1) ; -1 * ones(row , 1)];
    epsilon = 0.01;
    tolerance = 1e-6;
    error_cache= zeros(2 * row,1);
    b=0;
    c = zeros(2 * row , 1);
    c(1:row) = -1* y(1:row) - epsilon;
    c(row+1:2*row) = y(row+1:2*row) - epsilon;
    sigma2 = 10;
    K = zeros(row);
    for i = 1:row
        for j = i:row
            K(i,j) = svr_kernal_train( x(i,:) , x(j,:) , sigma2 );
            K(j,i) = K(i,j);
        end
    end
    temp = K;
    K = zeros(2*row);
    K(1:row,1:row) = temp;
    K(row+1:2*row,1:row) = temp;
    K(row+1:2*row,row+1:2*row) = temp;
    K(1:row,row+1:2*row) = temp;
    %the matrix H of alpha' * H *alpha - c' * alpha
    save svr_intial 'target' 'K';
end

