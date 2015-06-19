function [result] = svr_learned_func( i1)
    global target
    global K
    global row
    global alpha
    global b
    result = 0;
    for i = 1:2*row
        result = result - alpha(i)*target(i)*K(i1,i);
    end
    result = result + b;
end

