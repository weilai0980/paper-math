function [ result ] = svr_test_func( xx)
    global target
    global sigma2
    global row
    global alpha
    global b
    global x
    result = 0;
    x1 = xx;
    for i = 1:2*row  
        x2 = x(i,:);
        kk = svr_kernal_train( x1 , x2 , sigma2 );
        result = result - alpha(i)*target(i) * kk;
    end
    result = result + b;
    
end

