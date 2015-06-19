function finalSVM()




%% Split training set and validation set
ratio=1/3;
[ td, vd, tl, vl] ...
    =splitTrainingValidationSets(trainingdata_4and9,ratio);
display('Training and Validation Sets are splited')

%% Parameters

C=5;
tau=0.2;
gerr=0;
gcv;
% Number of patterns for training set
n=size(td,1);
d=size(td,2);


cvn=n/10;
cvcnt=0;
cverr;

%% main learing process
    
  % [ td, vd, tl, vl]=cvcon(trainingdata_3and5,cvn,cvcnt);
    
   td=trainingdata_3and5;
   n=size(td,1);
    
    %% kernel 
type='gauss';
x=td;
y=td;
switch type
    case 'linear'
        K = x'*y;
    case 'ploy'
        d = degree;
        c = offset;
        K = (x'*y+c).^d;
    case 'gauss'    
       
        rn = size(x,1);
        cn = size(x,2);   
        tmp= diag(x*x')*ones(rn,1)'+ones(rn,1)*diag(x*x')'-2*x*x';     
        K = exp(-0.5*(tmp));
    otherwise
        K = 0;
end
%% initialization
a=0;
f=-tl;

% Iup Ilow set 
Ip;
Ipcnt=0;
In;
Incnt=0;
Iz=0;
Izcnt=0;
for i=1:n
    if a(i)==0 && tl==1
        Ip(Ipcnt)=i;
        Ipcnt=Ipcnt+1;
    end
     if a(i)==0 && tl==-1
        In(Incnt)=i;
        Incnt=Incnt+1;
    end
end

bup=-1;
blow=1;
bupidx=Ip(randi(Ipcnt)); 
blowidx=In(randi(Incnt));

itercnt=0;
%% trainning loop
while(1)
   % results durinng learning phase
    itercnt=itercnt+1;
    phi= a'*ones(n,1)-0.5*(a'*diag(tl,0)*td)*(a'*diag(tl,0)*td)';
   
   
   
   
    
    %% select pair 
    i=blowidx;
    j=bupidx;
    
    if f(i) <= f(j)+2*tau
        i=-1;
        j=-1;
    end
    
    if j==-1
        break;
    end
    
    sigma= tl(i)*tl(j);
    gamma=a(i)+sigma*a(j);
    
    %% L H bound for a(j)
    if sigma==1
      if gamma>C 
      H=C;
      L=gamma-C;
      end
      if gamma <=C
      L=0;
      H=gamma;
      end
    elseif sigma==-1
        if gamma>0
        L=0;
        H=C-gamma;
        end
        if gamma<=0
        L=-gamma;
        H=C;
        end
    end
    
    eta=2*K(i,j)-K(i,i)-K(j,j);
    
    if eta<10e-15
       a(j)=a(j)+ tl(j)*(f(j)-f(i))/eta;
       deltaj=tl(j)*(f(j)-f(i))/eta;
       if a(j)>H
          a(j)=H;
       elseif a(j)<L
        a(j)=L;
       end
    else
        objL=0.5*eta*L*L+(tl(j)*(f(i)-f(j))-eta*a(j))*L;
        objH=0.5*eta*H*H+(tl(j)*(f(i)-f(j))-eta*a(j))*H;
        
        if objL>objH
            deltaj=L-a(j);
            a(j)=L;
        else
            deltaj=H-a(j);
            a(j)=H;
        end
    end
     a(i)=a(i)-sigma*deltaj;
     deltai=-sigma*deltaj;
    
     f=f+tl(i)*deltai*K(:,i)+tl(j)*deltaj*K(:,j);
     
     %% update set Ilow and Iup
Ip;
Ipcnt=1;
In;
Incnt=1;
Iz;
Izcnt=1;

bup;
blow;

for i=1:n
    if( a(i)==0 && tl==1) || ( a(i)==C && tl==-1)
    
  
        if Ipcnt==1
          bup=f(i);
        end
        Ip(Ipcnt)=i;
        Ipcnt=Ipcnt+1;
        
        if(f(i)<bup)
            bup=f(i);
            bupidx=i;
        end

    end
     if (a(i)==0 && tl==-1) || (a(i)==C && tl==1)
         
         if Incnt==1
          blow=f(i);
        end
         
        In(Incnt)=i;
        Incnt=Incnt+1;
        
        if(f(i)>blow)
            blow=f(i);
            blowidx=i;
        end
        
     end
     if a(i)>0 && a(i)<C
        Iz(Izcnt)=i;
        Izcnt=Izcnt+1;
        
         if(f(i)<bup)
            bup=f(i);
            bupidx=i;
         end
        
         if(f(i)>blow)
            blow=f(i);
            blowidx=i;
         end
     end
end
%% violations
    viocnt=0;
   for i=1:Ipcnt
       for j=1:Incnt
        if f(Ip(i))+2*tau <  f(In(j))
             viocnt=viocnt+1;  
        end
   end
   end
end


    
    

    








    