function [  ] = svr_test_result(  )
    global epsilon
    global x
    load housing_test.mat 'housing_test';
    [r,c] = size(housing_test);
    xx = housing_test(:,1:c-1);
%     xx = normlize( xx );
    yy = housing_test(:,c);
    y_test = zeros(r,3);
    for i = 1:r
        y_test(i,1) =  svr_test_func( xx(i,:));
    end
    y_test(:,2) = yy + epsilon;
    y_test(:,3) = yy - epsilon;
    subplot(2,1,2);
    plot(y_test)
    save svr_test_result 'y_test' 'x' 'xx';
    
end

