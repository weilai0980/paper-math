 tmpmax=f(1);
    for k=1:Ipcnt
        if f( Ip(k))>tmpmax
            i=Ip(k);
        end
    end
    tmpmin=f(1);
    for k=1:Incnt
        if f( In(k))<tmpmin
            j=In(k);
        end
    end
    
    for k=1:Izcnt
        if f( Iz(k))>tmpmax
            i=Iz(k);
        end
        if f( Iz(k))<tmpmin
            j=Iz(k);
        end
    end