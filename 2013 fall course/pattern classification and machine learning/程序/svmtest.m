N=100;
A = rand(N,2)-0.6;
B = rand(N,2)+0.6;
plot(A(:,1),A(:,2),'*', B(:,1), B(:,2),'o');
H =[A;B];
y=[-ones(N,1);ones(N,1)];
Q = diag(y)*H*H'*diag(y);
Q =Q+0.001*eye(2*N);
options = optimset('LargeScale','off');
[alfa,f,flag]=quadprog(Q , -ones(2*N,1),[],[],y',0,zeros(2*N,1),[],[],options);
%[alfa,f,flag]=quadprog(Q , -ones(2*N,1),[],[],y',0,zeros(2*N,1),[],alfa,options);
%计算b
I = find(alfa>1e-3);
b = mean(y(I)-H(I,:)*H'*(alfa.*y));
%%%plot
a=axis;
X=a(1):(a(2)-a(1))/100:a(2);
Y=a(3):(a(4)-a(3))/100:a(4);
[X,Y] = meshgrid(X,Y);
for i=1:101
    for j=1:101
        Z(i,j) = [X(i,j) Y(i,j)]*H'*(alfa.*y);
    end
end
Z=Z+b;
hold on;
contour(X,Y,Z,[+1 +1],'b');
contour(X,Y,Z,[+0 +0],'r');
contour(X,Y,Z,[-1 -1],'g');
return
%另一个数据实验,用gauss核函数,sigma^2 = 0.88
N=100;a=0.2;b=1.8;
I=(0:4*pi/(N-1):4*pi)';
A=[(0.5*I+a).*cos(I) (0.5*I+a).*sin(I)];
B=[(0.5*I+b).*cos(I) (0.5*I+b).*sin(I)];
plot(A(:,1),A(:,2),'*', B(:,1), B(:,2),'o');
