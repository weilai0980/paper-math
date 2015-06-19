function [ found] =svr_Examine2( i1 )
    global C
    global row
    global alpha  
    startpoint = ceil(mod(2* row, rand(1) * 2*row ));
    for k = startpoint:2*row
        i2 = k;
        if alpha(i2)>0 && alpha(i2)<C
            if svr_takestep(i1,i2)
                found=1;
                return;
            end
        end
    end
    for k = 1:startpoint-1
        i2 = k;
        if alpha(i2)>0 && alpha(i2)<C
            if svr_takestep(i1,i2)
                found=1;
                return;
            end
        end
    end
    found=0;
    return;
end

