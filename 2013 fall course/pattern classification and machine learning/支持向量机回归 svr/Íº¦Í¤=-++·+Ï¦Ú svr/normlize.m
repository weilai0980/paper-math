function [ result ] = normlize( x )
    [r,c] = size(x);
    for i = 1:c
       x(:,i) =x(:,i)/max(x(:,i));
    end
    result = 10*x;
end

