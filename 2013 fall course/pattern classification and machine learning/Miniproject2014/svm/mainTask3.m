function mainTask3()

load(['data_4and9.mat'],'trainingdata_4and9');

load(['data49.mat'],'testdata_4and9');

%% Split training set and validation set
data=trainingdata_4and9.normdata;
label=trainingdata_4and9.label;

testdata=testdata_4and9.normdata;
testlab=testdata_4and9.label;

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

n=size(data,1);
d=size(data,2);

%fid = fopen('task2-svm4.txt','w');
%fid2 = fopen('task2-kkt4.txt','w');

%best
%C=4 gtau=0.08

C=4;
%tau=0.0000001;
tau=0.04;
gtau=0.08;

        
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
    
    
    fprintf('Round %d:  objective function %f %f %f\n', itercnt,phi,f(i),f(j));
 

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
     
%% update set Ilow and Iup

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

 
end

fprintf('finish learning loop\n');


%% compute b 

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


%% on the trainning data

tn=size(td,1);
poscnt=0;
negcnt=0;

const=diag(td*td');
constw=a*diag(tl,0);

for i=1:tn
    
    vT=const+ones(n,1)*(td(i,:)*td(i,:)')-2*td*td(i,:)';
    vK = exp(-0.5*gtau*(vT));
    y= constw*vK+b;
    
    if tl(i)*y>0
        poscnt=poscnt+1;
    else
        negcnt=negcnt+1;
    end
end
    
fprintf('finish on training set  %d %d %f\n',poscnt,negcnt,negcnt/tn);


% on the test data

testn=size(testdata,1);
poscnt=0;
negcnt=0;

const=diag(td*td');
constw=a*diag(tl,0);

for i=1:testn
 
    vT=const+ones(n,1)*(testdata(i,:)*testdata(i,:)')-2*td*testdata(i,:)';
    vK = exp(-0.5*gtau*(vT));
    y= constw*vK+b;
    
    if testlab(i)*y>0
        poscnt=poscnt+1;
    else
        negcnt=negcnt+1;
    end
end
    
fprintf('finish on test set  %d %d %f\n',poscnt,negcnt,negcnt/testn);


%fclose(fid);
%fclose(fid2);

%h1=figure(1);

%plot(x,mrktup,'-xk');
%hold on;
%xlim([0.0 80]);
%xlabel('Selectivity of time range query[%]');
%ylabel('Number of accessed tuples');

%set(findall(gcf,'type','text'),'fontSize',14,'fontWeight','bold');


%saveTightFigure(h5,'C:\Users\guo\paper work 2013\DASSFA 2013\Oct 30\figs\exp\tiT.pdf');






    