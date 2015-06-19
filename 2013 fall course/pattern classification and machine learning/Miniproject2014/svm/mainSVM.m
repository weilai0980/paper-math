function mainSVM()

load(['data_4and9.mat'],'trainingdata_4and9');

%% Split training set and validation set



data=trainingdata_4and9.normdata;
label=trainingdata_4and9.label;


%permutation

n=size(data,1);
rtmp=0;
for i=1:n
   rtmp=randi(n,1,1);
   tmpd(1,:)=data(i,:);
   tmpl(1,:)=label(i,:);
   
   data(i,:)=data(rtmp,:);
   data(rtmp,:)=tmpd(1,:);
   
   label(i,:)=label(rtmp,:);
   label(rtmp,:)=tmpl(1,:);
   
end

%% Parameters


gerr=0;
gcv=0;
% Number of patterns for training set
n=size(data,1);
d=size(data,2);

cvn=n/10;
cvcnt=0;
cverr=0;

fid = fopen('outputEnhan.txt','w');

C=5;
tau=0.04;
gtau=0.05;
%for C=9:9
%   for gtau=1:1:5

err=0;

for cvcnt=0:9
    
    
    
%% main learing process 
[td, vd, tl, vl]=cvcon(data,label,cvn,cvcnt);
display('data ready')    

%% kernel 
type='gauss';
x=td;
y=td;

n=size(td,1);
d=size(td,2);

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
        
        K = exp(-0.5*gtau*(tmp));      
    otherwise
        K = 0;
end
%% initialization
a(1:n)=0;
f(1:n)=-tl;


Ipcnt=1;
Incnt=1;
Izcnt=1;

for i=1:n
    if a(i)==0 && tl(i)==1
        Ipf(i)=f(i);
        Ip(i)=1;
      
        Iparr(Ipcnt)=i;
        Ipcnt=Ipcnt+1;
        
    else
        Ipf(i)=100.0;
        Ip(i)=0;
    end
    
    if a(i)==0 && tl(i)==-1
        Inf(i)=f(i);
        In(i)=1;     
        
        Inarr(Incnt)=i;
        Incnt=Incnt+1;
    else
        Inf(i)=-100.0;
        In(i)=0;
    end
   
end

[valp,idxp] = min(Ipf);
[valn,idxn] = max(Inf);

bupidx=Iparr(1); 
blowidx=Inarr(1);

itercnt=0;
%% trainning loop


while(1)
  itercnt=itercnt+1;
   
  phi=0;
  phi=phi+ a*diag(tl,0)*(a*diag(tl,0)*K)'; 
  phi=0.5*phi- a*ones(n,1);
 
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
    gamma=sigma*a(i)+a(j);
    
    
    fprintf('objective function %f %f %f %f %f %d %d\n', phi,f(i),Inf(i),f(j),Ipf(j),i,j);

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
        L=gamma;
        H=C;       
        end 
        if gamma<=0
        L=0;
        H=C+gamma;    
        end
  
    end
   
    eta=K(i,i)+K(j,j)-2*K(i,j);    
    tmp=0;
    if eta>10e-15 
       tmp=a(j)+ tl(j)*(f(i)-f(j))/eta;   
       if tmp> H
          deltaj=H-a(j);
          a(j)= H;
       elseif tmp<L
        deltaj=L-a(j);
        a(j)=L;
       else
         deltaj=tl(j)*(f(i)-f(j))/eta;
         a(j)=tmp;
       end
    else
        Li=a(i)+sigma*a(j)-sigma*L;
        vi=f(i)+tl(i)-a(i)*tl(i)*K(i,i)-a(j)*tl(j)*K(i,j);
        vj=f(j)+tl(j)-a(i)*tl(i)*K(i,j)-a(j)*tl(j)*K(j,j);
        objL=0.5*(K(i,i)*Li*Li+K(j,j)*L*L)+sigma*K(i,j)*Li*L+tl(i)*Li*vi+tl(j)*L*vj-Li-L;
        
        Hi=a(i)+sigma*a(j)-sigma*H;
        objH=0.5*(K(i,i)*Hi*Hi+K(j,j)*H*H)+sigma*K(i,j)*Hi*H+tl(i)*Hi*vi+tl(j)*H*vj-Hi-H;
        
        if objL>objH
            deltaj=H-a(j);
            a(j)=H;
        else
            deltaj=L-a(j);
            a(j)=L;
        end
    end
     a(i)=a(i)-sigma*deltaj;
     deltai=-sigma*deltaj;
     deltaf=tl(i)*deltai*K(:,i)'+tl(j)*deltaj*K(:,j)';
          
     
%% update set Ilow and Iup

if( a(i)==0 && tl(i)==1) || ( a(i)==C && tl(i)==-1)
     Ip(i)=1;
     Ipf(i)=f(i);
  
     In(i)=0;
     Inf(i)=-100.0;
elseif (a(i)==0 && tl(i)==-1) || (a(i)==C && tl(i)==1)  
     In(i)=1;
     Inf(i)=f(i);
    
     Ip(i)=0;
     Ipf(i)=100.0;
elseif a(i)>0 && a(i)<C
    Ip(i)=1;
    Ipf(i)=f(i);
    In(i)=1; 
    Inf(i)=f(i);
end

if( a(j)==0 && tl(j)==1) || ( a(j)==C && tl(j)==-1)
  
     Ip(j)=1;
     Ipf(j)=f(j);

        In(j)=0;
        Inf(j)=-100.0;

elseif (a(j)==0 && tl(j)==-1) || (a(j)==C && tl(j)==1)
         
      In(j)=1;  
      Inf(j)=f(j);
    
         Ip(j)=0;
         Ipf(j)=100.0;
    
        
elseif a(j)>0 && a(j)<C
 
    Ip(j)=1;
    Ipf(j)=f(j);
    In(j)=1; 
    Inf(j)=f(j); 
end

Ipf=Ipf+(diag(Ip)*deltaf')';
Inf=Inf+(diag(In)*deltaf')';

[valp,idxp] = min(Ipf);
[valn,idxn] = max(Inf);

bupidx=idxp; 
blowidx=idxn;

f=f+tl(i)*deltai*K(:,i)'+tl(j)*deltaj*K(:,j)';
end
fprintf('finish learning loop\n');
%% compute b 
%w= vd'*diag(vl,0)*a;
tmpsum=0;
cnt=0;

const=a*diag(tl,0);

for i=1:n
    if a(i)>0 && a(i)<C
        cnt=cnt+1;
        tmpsum=tmpsum+(tl(i)- const*K(:,i));
    end
end
b=tmpsum/cnt;

fprintf('finish computing b\n');

%% test on validation data

vn=size(vd,1);
poscnt=0;
negcnt=0;

const=diag(td*td');
constw=a*diag(tl,0);

preerr=err;
for i=1:vn

    %fprintf('current iteration %d\n',i);
    
    vT=const+ones(n,1)*(vd(i,:)*vd(i,:)')-2*td*vd(i,:)';
    vK = exp(-0.5*(vT));
    y= constw*vK+b;
    
    err=err+ (y-vl(i))*(y-vl(i));
    
    if vl(i)*y>=0
        poscnt=poscnt+1;
    else
        negcnt=negcnt+1;
    end
end
    
fprintf('finish testing on validation set\n');


fprintf('one CV square error %f\n',(err-preerr)/(n/10));    
fprintf('right: %f\n',poscnt);  
fprintf('wrong: %f\n',negcnt);  


fprintf(fid, 'CV file %d:  right:%d    wrong:%d   CV square error: %f\n', cvcnt, poscnt,negcnt,(err-preerr)/(n/10));
  
    
end

err=err/n;
fprintf(fid,'  CV total risk: %f\n, C: %f   tau: %f\n',err, C, tau); 


 %  end
%end
%cverr(cvcnt+1)=err;    
%if cvcnt==0
%    gerr=err;
%    gcv=cvcnt;
%else
%    if err<gerr
%        gerr=err;
%        gcv=cvcnt;
%    end
%end

fclose(fid)
    








    