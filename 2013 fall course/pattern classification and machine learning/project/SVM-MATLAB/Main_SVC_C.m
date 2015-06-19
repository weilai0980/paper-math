% ֧��������Matlab������1.0 - C-SVC, C��������㷨
% ʹ��ƽ̨ - Matlab6.5
% ��Ȩ���У�½�񲨣��������̴�ѧ
% �����ʼ���luzhenbo@yahoo.com.cn
% ������ҳ��http://luzhenbo.88uu.com.cn
% �������ף�Chih-Chung Chang, Chih-Jen Lin. "LIBSVM: a Library for Support Vector Machines"
%
% Support Vector Machine Matlab Toolbox 1.0 - C Support Vector Classification
% Platform : Matlab6.5 / Matlab7.0
% Copyright : LU Zhen-bo, Navy Engineering University, WuHan, HuBei, P.R.China, 430033  
% E-mail : luzhenbo@yahoo.com.cn        
% Homepage : http://luzhenbo.88uu.com.cn     
% Reference : Chih-Chung Chang, Chih-Jen Lin. "LIBSVM: a Library for Support Vector Machines"
%
% Solve the quadratic programming problem - "quadprog.m"

%clc
clear
%close all

% ------------------------------------------------------------%
% ����˺�������ز���

C = 200;                % �������ճ����Ͻ�

ker = struct('type','linear');
%ker = struct('type','ploy','degree',3,'offset',1);
%ker = struct('type','gauss','width',1);
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
randn('state',6);
x1 = randn(2,n);
y1 = ones(1,n);
x2 = 5+randn(2,n);
y2 = -ones(1,n);

figure(1);
plot(x1(1,:),x1(2,:),'bx',x2(1,:),x2(2,:),'k.');
axis([-3 8 -3 8]);
title('C-SVC')
hold on;

X = [x1,x2];        % ѵ������,d��n�ľ���,nΪ��������,dΪ����ά��
Y = [y1,y2];        % ѵ��Ŀ��,1��n�ľ���,nΪ��������,ֵΪ+1��-1

% ------------------------------------------------------------%
% ѵ��֧��������

tic
svm = svmTrain('svc_c',X,Y,ker,C);
t_train = toc

% svm  ֧��������(�ṹ�����)
% the following fields:
%   type - ֧������������  {'svc_c','svc_nu','svm_one_class','svr_epsilon','svr_nu'}
%   ker - �˲���
%   x - ѵ������,d��n�ľ���,nΪ��������,dΪ����ά��
%   y - ѵ��Ŀ��,1��n�ľ���,nΪ��������,ֵΪ+1��-1
%   a - �������ճ���,1��n�ľ���

% ------------------------------------------------------------%
% Ѱ��֧������

a = svm.a;
epsilon = 1e-8;                     % ���С�ڴ�ֵ����Ϊ��0
i_sv = find(abs(a)>epsilon);        % ֧�������±�
plot(X(1,i_sv),X(2,i_sv),'ro');

% ------------------------------------------------------------%
% �������

[x1,x2] = meshgrid(-2:0.1:7,-2:0.1:7);
[rows,cols] = size(x1);
nt = rows*cols;                  % ����������
Xt = [reshape(x1,1,nt);reshape(x2,1,nt)];

tic
Yd = svmSim(svm,Xt);           % �������
t_sim = toc

Yd = reshape(Yd,rows,cols);
contour(x1,x2,Yd,[0 0],'m');    % ������
hold off;



