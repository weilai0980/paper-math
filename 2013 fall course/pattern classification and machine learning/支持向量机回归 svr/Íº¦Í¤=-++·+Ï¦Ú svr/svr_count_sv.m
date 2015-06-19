function [ count_sv] = svr_count_sv(  )
    global C
    global row
    global alpha  
    
    count = 0;
    for i = 1:2*row
        if alpha(i)>0 && alpha(i)<C
            count = count+1;
        end
    end
    count_sv = count;
end

