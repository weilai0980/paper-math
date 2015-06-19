function [ success ] = svr_takestep(i1,i2 )
    global y
    global C
    global target
    global tolerance
    global error_cache
    global row
    global alpha
    global K
    global b
    
    if i1 == i2
        success = 0;
        return;
    end
    
    alpha1 = alpha(i1);
    alpha2 = alpha(i2);
    t1 = target(i1);
    t2 = target(i2);
    
    if alpha1>0 && alpha1<C
        E1 = error_cache( i1);
    else
        E1 = svr_learned_func(i1) - y(i1);
    end
    
    if alpha2>0 && alpha2<C
        E2 = error_cache(i2);
    else
        E2 = svr_learned_func(i2) - y(i2);
    end
    s = t1*t2;
    if t1 == t2
        L = max(0,alpha1+alpha2-C);
        H = min(C,alpha1+alpha2);
    else 
        L = max(0,alpha2-alpha1);
        H = min(C,C+alpha2-alpha1);
    end
    
    if L == H
        success = 0;
        return;
    end
    
    k11 = K(i1,i1);
    k22 = K(i2,i2);
    k12 = K(i1,i2);
    eta = 2*k12 - k11 -k22;
    
    if eta > 0
        a2 = alpha2 + t2*(E2 - E1) / eta;
         if a2 < L 
            a2 = L;
        else if a2 > H
                a2 = H;
            end
        end
    else
        c1 = eta/2;
        c2 = t2 * (E2 - E1) - eta * alpha2;
        lobj = c1 * L * L + c2 * L;
        hobj = c1 * H * H + c2 * H;
        
        if lobj > hobj + tolerance
            a2 = L;
        elseif lobj < hobj - tolerance
                a2 = H; 
        else
            a2 = alpha2;
        end
    end
    
    if abs(a2-alpha2)< tolerance * (a2 + alpha2 +tolerance)
        success = 0;
        return;
    end
    
    a1 = alpha1 + s * (alpha2 - a2);
    if a1 < 0
        a2 = a2 + s * a1;
        a1 = 0;
    else if a1 > C
            a2 = a2 + s * (a1 - C);
            a1 = C;
        end
    end
    
    if a1>0 && a1<C
         bnew = b - E1 -t1*(a1 - alpha1)*k11 - t2 * (a2 - alpha2) * k12;
    else 
        if a2>0 && a1 <C
            bnew = b - E2 - t1 * (a1 - alpha1)*k12 - t2 * (a2 - alpha2)*k22;
        else
            b1 = b - E1 - t1*(a1 - alpha1)*k11 - t2*(a2 - alpha2)*k12;
            b2 = b - E2 - t1*(a1 - alpha1)*k12 - t2*(a2 - alpha2)*k22;
            bnew = (b1 + b2)/2;
        end
    end
    
    delta_b = bnew - b;
%     fprintf('delta_b == %d,b == %d\n',delta_b,b);
    b = bnew;
    
    for k = 1:2*row
        if alpha(k)>0 && alpha(k)<C
            error_cache(k) = error_cache(k) + t1*(a1-alpha1)*K(i1,k) +t2*(a2-alpha2) *K(i2,k)-delta_b;
        end
    end
    
    error_cache(i1)=0;
    error_cache(i2)=0;
    alpha(i1) = a1;
    alpha(i2) = a2;
    success = 1;
    return;
end

