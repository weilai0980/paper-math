function [ result ] = svr_kernal_train( x1 , x2 , sigma2 )
    s = x1 * x1' + x2 * x2' - 2 * x1 * x2';
    result = exp(-s/sigma2);   
end

