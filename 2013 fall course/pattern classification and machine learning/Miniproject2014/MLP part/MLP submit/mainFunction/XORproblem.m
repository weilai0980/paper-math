%% XOR problem

x=[0 1 0 1;0 1 1 0];
t=[-1 -1 1 1];

d=2;
h1=4;

w1=1/sqrt(d)*rand(d,h1);
b1=1/sqrt(d)*rand(h1,1);

w2=1/sqrt(h1)*rand(h1,1);
b2=1/sqrt(h1)*rand(h1,1);

a1=(w1'*x)+b;