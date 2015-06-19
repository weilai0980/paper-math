function [ is ] = svr_ExamineExample( i1)
    global x
    global y
    global C
    global target
    global epsilon
    global tolerance
    global error_cache
    global sigma2
    global H
    global row
    global alpha

    alpha1 = alpha(i1);
    if alpha1 > 0 && alpha1 < C
        E1 = error_cache( i1);
    else
% svr_learned_func(i1)
        E1 = svr_learned_func(i1) - y(i1);
    end

% judge if alpha1 fit the KKT condition
    if (alpha1~=0 && target(i1)>0 && E1<epsilon-tolerance)||(alpha1~=0 && target(i1)<0 && E1 >-1*epsilon+tolerance)||(alpha1~=C&& target(i1)>0 && E1>epsilon+tolerance)||(alpha1~=C && target(i1)<0&&E1<-epsilon-tolerance)
        if svr_Examine1(i1,E1)
            is=1;
            return;
        end
        if svr_Examine2(i1)
            is=1;
            return;
        end
        if svr_Examine3(i1)
            is=1;
            return;
        end
    end
 
    is = 0;
    return;

end

