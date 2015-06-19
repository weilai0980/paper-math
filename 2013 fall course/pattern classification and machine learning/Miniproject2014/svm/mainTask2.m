function mainTask2()

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

n=size(data,1);
d=size(data,2);

cvn=n/10;
cvcnt=0;
cverr=0;

fid = fopen('task2-svm4.txt','w');
fid2 = fopen('task2-kkt4.txt','w');

C=4;
tau=0.0000001;
gtau=0.08;


%best

%C=4 gtau=0.08



err=0;
    

    
%% main learing process 

td=data;
tl=label;
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

for i=1:n
 Iz(i)=0;
    
    if a(i)==0 && tl(i)==1
       
        Ip(i)=1;
        
        Iparr(Ipcnt)=i;
        Ipcnt=Ipcnt+1; 
    else  
        Ip(i)=0;
    end
    
    if a(i)==0 && tl(i)==-1
    
        In(i)=1;     
    
        Inarr(Incnt)=i;
        Incnt=Incnt+1;
    else 
        In(i)=0;
    end
   
end

%[valp,idxp] = min(Ipf);
%[valn,idxn] = max(Inef);

bupidx=Iparr(1); 
blowidx=Inarr(1);

itercnt=0;
%% trainning loop

phicnt=1;
viocnt=1;

n

while(1)
  itercnt=itercnt+1;
   
  phi=0;
  phi=phi+ a*diag(tl,0)*(a*diag(tl,0)*K)'; 
  phi=0.5*phi- a*ones(n,1);
  
  if mod(itercnt, 20)==0
    phiarr(phicnt)=phi;
    phicnt=phicnt+1;
    fprintf(fid, '%f\n', phi);
  end
  
 
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
     
     %deltaf=tl(i)*deltai*K(:,i)'+tl(j)*deltaj*K(:,j)';
          
     
%% update set Ilow and Iup

oldfi=f(i);
oldfj=f(j);

f=f+tl(i)*deltai*K(:,i)'+tl(j)*deltaj*K(:,j)';

if( a(i)==0 && tl(i)==1) || ( a(i)==C && tl(i)==-1)
     Ip(i)=1;
     In(i)=0;
     Iz(i)=0;
  
elseif (a(i)==0 && tl(i)==-1) || (a(i)==C && tl(i)==1)  
     In(i)=1;
     Ip(i)=0;
     Iz(i)=0;

elseif a(i)>0 && a(i)<C
    Iz(i)=1;
end

if( a(j)==0 && tl(j)==1) || ( a(j)==C && tl(j)==-1)
  
     Ip(j)=1;
     In(j)=0;
     Iz(j)=0;

elseif (a(j)==0 && tl(j)==-1) || (a(j)==C && tl(j)==1)
         
      In(j)=1;  
      Ip(j)=0;
      Iz(j)=0;
            
elseif a(j)>0 && a(j)<C
    Iz(j)=1;
end

Ipf=f+1000.0.*In;
Inef=f-1000.0.*Ip;

%Ipf=Ipf+(diag(Ip)*deltaf')';
%Inf=Inf+(diag(In)*deltaf')';

[valp,idxp] = min(Ipf);
[valn,idxn] = max(Inef);

bupidx=idxp; 
blowidx=idxn;

%valp
%valn

vionum=0;
for k=1:n

if Ip(k)==1
    if f(k) < valn
        vionum=vionum+1;
    end
end
if In(k)==1
    if f(k) > valp
       vionum=vionum+1;
    end
end
if Iz(k)==1
    if f(k) < valn
        vionum=vionum+1;
    end
  % if f(k) > valp
  %     vionum=vionum+1;
  %  end 
end

end


 fprintf('Round %d:  objective function %f %f %f %d\n', itercnt,phi,oldfi,oldfj,vionum);

 if mod(itercnt, 20)==0
    vioarr(viocnt)=vionum;
    viocnt=viocnt+1;
    fprintf(fid2, '%f\n', vionum);
 end
  


end

Iz*ones(n,1)

fprintf('finish learning loop\n');


fclose(fid);
fclose(fid2);

%h1=figure(1);

%plot(x,mrktup,'-xk');
%hold on;
%xlim([0.0 80]);
%xlabel('Selectivity of time range query[%]');
%ylabel('Number of accessed tuples');

%set(findall(gcf,'type','text'),'fontSize',14,'fontWeight','bold');


%saveTightFigure(h5,'C:\Users\guo\paper work 2013\DASSFA 2013\Oct 30\figs\exp\tiT.pdf');






    