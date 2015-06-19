% ֧��������Matlab������1.0 - Nu-SVR, Nu�ع��㷨
% ʹ��ƽ̨ - Matlab6.5 
% ��Ȩ���У�½�񲨣��������̴�ѧ
% �����ʼ���luzhenbo@yahoo.com.cn
% ������ҳ��http://luzhenbo.88uu.com.cn
% �������ף�Chih-Chung Chang, Chih-Jen Lin. "LIBSVM: a Library for Support Vector Machines"
%
% Support Vector Machine Matlab Toolbox 1.0 - Nu Support Vector Regression
% Platform : Matlab6.5 / Matlab7.0
% Copyright : LU Zhen-bo, Navy Engineering University, WuHan, HuBei, P.R.China, 430033  
% E-mail : luzhenbo@yahoo.com.cn        
% Homepage : http://luzhenbo.88uu.com.cn     
% Reference : Chih-Chung Chang, Chih-Jen Lin. "LIBSVM: a Library for Support Vector Machines"
%
% Solve the quadratic programming problem - "quadprog.m"

clc
clear
%close all

% ------------------------------------------------------------%
% ����˺�������ز���

C = 100;                % �������ճ����Ͻ�
nu = 0.05;              % nu -> (0,1] ��֧������������Ͼ���֮���������

%ker = struct('type','linear');
%ker = struct('type','ploy','degree',3,'offset',1);
ker = struct('type','gauss','width',0.6);
%ker = struct('type','tanh','gamma',1,'offset',0);

% ker - �˲���(�ṹ�����)
% the following fields:
%   type   - linear :  k(x,y) = x'*y
%            poly   :  k(x,y) = (x'*y+c)^d
%            gauss  :  k(x,y) = exp(-0.5*(norm(x-y)/s)^2)
%            tanh   :  k(x,y) = tanh(g*x'*y+c)
%   degree - Degree d of polynomial kernel (positive scalar).
%   offset - Offset c of polynomial and tanh kernel (scalar, negative for tanh).
%   width  - Width s of Gauss kernel (positive scalar).
%   gamma  - Slope g of the tanh kernel (positive scalar).

% ------------------------------------------------------------%
% ��������ѵ������

n = 50;
rand('state',42);
X  = linspace(-4,4,n);                            % ѵ������,d��n�ľ���,nΪ��������,dΪ����ά��,����d=1
Ys = (1-X+2*X.^2).*exp(-.5*X.^2);
f = 0.2;                                          % ������
Y  = Ys+f*max(abs(Ys))*(2*rand(size(Ys))-1)/2;    % ѵ��Ŀ��,1��n�ľ���,nΪ��������,ֵΪ�������

figure;
plot(X,Ys,'b-',X,Y,'b*');
title('\nu-SVR');
hold on;

% ------------------------------------------------------------%
% ѵ��֧��������

tic
svm = svmTrain('svr_nu',X,Y,ker,C,nu);
t_train = toc

% svm  ֧��������(�ṹ�����)
% the following fields:
%   type - ֧������������  {'svc_c','svc_nu','svm_one_class','svr_epsilon','svr_nu'}
%   ker - �˲���
%   x - ѵ������,d��n�ľ���,nΪ��������,dΪ����ά��
%   y - ѵ��Ŀ��,1��n�ľ���,nΪ��������
%   a - �������ճ���,1��n�ľ���

% ------------------------------------------------------------%
% Ѱ��֧������

a = svm.a;
epsilon = 1e-8;                     % ���"����ֵ"С�ڴ�ֵ����Ϊ��0
i_sv = find(abs(a)>epsilon);        % ֧�������±�,�����abs(a)�����ж�
plot(X(i_sv),Y(i_sv),'ro');

% ------------------------------------------------------------%
% �������

tic
Yd = svmSim(svm,X);           % �������
t_sim = toc

plot(X,Yd,'r--');
hold off;
