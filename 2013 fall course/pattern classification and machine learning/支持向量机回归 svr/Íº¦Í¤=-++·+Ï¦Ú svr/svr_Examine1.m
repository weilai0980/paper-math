function [found ] = svr_Examine1(i1,E1)
    global C
    global error_cache
    global row
    global alpha
    i2 = -1;
    tmax = 0;
    startpoint = ceil(mod(2* row, rand(1) * 2*row ));
    for k = startpoint:2*row
        if alpha(k)>0 && alpha(k)<C 
            E2 = error_cache(k);
            temp = abs(E1 - E2);
            if temp>tmax
                tmax = temp;
                i2 = k;
            end
        end
    end
    for k = 1:startpoint-1
        if alpha(k)>0 && alpha(k)<C 
            E2 = error_cache(k);
            temp = abs(E1 - E2);
            if temp>tmax
                tmax = temp;
                i2 = k;
            end
        end
    end
    
    if i2 > 0
        if svr_takestep(i1, i2)
            found = 1;
            return;
        end
    end
    
    found = 0;
    return;

end

