%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%%%%%%%%%%%%%%%%SMO_C   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
function [x,it,f,cache]=SMO_new(H,y,sigm,espl,C,flag)
%%%%适用于任意核函数
N1=sum(y>0); N2=sum(y<0);
norm=sum(H.*H,2);
NN=50;
cache.index=zeros(1,N1+N2); 
cache.frequency=zeros(1,NN);
cache.kernel=zeros(N1+N2,NN);
if isempty(C); C=1e7;end
%%%%以0作为初始值
%if isempty(x)
x=zeros(N1+N2,1);   
%end
current=0;
f=0;
gy=-y;
it=0;       MAXIT=500*(N1+N2);%  MAXITINNER=(N1+N2);
I_up=find(y>0);    I_low=find(y<0);
[max_low,indexLow]=max(gy(I_low));          IB=I_low(indexLow);
[min_up,indexUp]=min(gy(I_up));             IA=I_up(indexUp);
while it<MAXIT && max_low-min_up > espl 
    it=it+1;
    %%%%%%%%%计算核矩阵对应对应IA、IB列
    indexA=cache.index(IA);
    if ~indexA %%%%%%IA列还没有计算
        current = current +1;
        cache.index(IA)=current;
        cache.frequency(current)=1;
        cache.kernel(:,current) = inner_kernel(H,H(IA,:)',norm,norm(IA),sigm,flag);
        indexA=current;
    else%%%%%%IA列有计算
        cache.frequency(indexA)=cache.frequency(indexA)+1;
    end
    indexB=cache.index(IB);
    if ~indexB %%%%%%IB列还没有计算
        current = current +1;
        cache.index(IB)=current;
        cache.frequency(current)=1;
        cache.kernel(:,current) = inner_kernel(H,H(IB,:)',norm,norm(IB),sigm,flag);
        indexB=current;
    else %%%%%%IB列有计算
        cache.frequency(indexB)=cache.frequency(indexB)+1;
    end
    %%%%%%%%%%核计算结束
    
    %%%%%%%%%计算二次方程系数
    a=(cache.kernel(IA,indexA)+cache.kernel(IB,indexB))-2*cache.kernel(IA,indexB);
    b =y(IA)*(gy(IA)-gy(IB));
    
    if y(IA) == y(IB)
        t1=max([-x(IA), x(IB)-C, min([C-x(IA) x(IB) -b/a])]);
        t2 =  -t1;
    else
        t1=max([-x(IA), -x(IB), min([C-x(IA) C-x(IB) -b/a])]);
        t2 = t1;
    end
%     t1 = min(C-x(IA),max(-x(IA),-b/a));
%     t2 = -y(IA)*y(IB)*t1;
    x(IA) = t1 + x(IA);
    x(IB) = t2 + x(IB);
    f = f + t1*(a*t1/2+b);
    gy = gy + cache.kernel(:,indexA)*(y(IA)*t1) + cache.kernel(:,indexB)*(y(IB)*t2);
    I_up=[find(x(1:N1)< C); find(x(N1+1:end)>0)+N1];
    I_low=[find(x(1:N1)>0); find(x(N1+1:end)<C)+N1];
    [max_low,indexLow]=max(gy(I_low));      IB=I_low(indexLow);
    [min_up,indexUp]=min(gy(I_up));         IA=I_up(indexUp); 
end
return 

function v_ker = inner_kernel(A,x,normA,normx,sigm,flag)%%kernel function.
if isempty(flag)
    flag=0;
end
n=size(x,2);
tmp = A*x;
if n==1
    if flag
        v_ker=tmp.*exp(-sigm*(normA-2*tmp+ normx ));
    else
        v_ker=exp(-sigm*(normA-2*tmp+ normx ));
    end
else
    if flag
        v_ker=tmp.*exp(-sigm*(normA*ones(1,n)-2*tmp + ones(size(A,1),1)*normx'));
    else
        v_ker=exp(-sigm*(normA*ones(1,n)-2*tmp + ones(size(A,1),1)*normx'));
    end
end
return


    
        
        