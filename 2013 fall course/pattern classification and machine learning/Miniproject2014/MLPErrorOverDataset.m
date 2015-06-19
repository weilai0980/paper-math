function [ Elogi, Elog, a2 ] = MLPErrorOverDataset( x, t, parameter )

% Number of input data points
N=size(x,1); 

% First hidden layer activations
a1=parameter.w1*x'+repmat(parameter.b1,1,N);

% Second hidden layer activations
a2=(parameter.w2'*gating(a1(1:2:end,:),a1(2:2:end,:)))+repmat(parameter.b2,1,N);

% Compute MLP Logistic Error
[Elogi,Elog]=LogisticError(t',a2);

end