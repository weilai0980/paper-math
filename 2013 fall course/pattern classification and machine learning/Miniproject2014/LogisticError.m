function [ Elogi, Elog ] = LogisticError( ti, ai )

% This function computes the logistic error for the given output layer
% activation(s) and label(s), providing the error component for each
% output-label pair and also the mean logistic error.
% This function is used for binary classification with MLP.
%
% Inputs:
%   ti: label(s) of the data point(s) (1xN vector)
%	ai: output layer activation(s) (1xN vector)
% 
% Outputs:
%	Elogi: logistic error for each output-label pair (1xN vector)
%   Elog:  mean logistic error (scalar)
%          If error is calculated for a single output-label pair
%          Instead of:
%          [Elogi,Elog]=computeBinaryMLPLogisticError(ti,ai); 
%          You can use:
%          Elog=computeBinaryMLPLogisticError(ti,ai);
%          The output should be a number.

% Check that the inputs are row vectors of the same size
% The inputs should be row vectors
%assert(isvector(ti)&&size(ti,1)==1,...
%    'Labels should be given as a scalar or a row vector'); 
assert(isvector(ai),size(ai,1)==1,...
    'Output layer activations should be given as a scalar or a row vector'); 
% The inputs should be of the same size
assert(isequal(size(ti),size(ai)),...
    'Labels and output layer activations should be of the same size');

% Formula for logistic error: Elogi=log(1+e^(-ti*ai))
x=-ti.*ai;
% Elogi=log(1+exp(x))
% For positive and negative values of ti*ai, different functions are used
% to compute Elogi to prevent computational errors.
% x<0, small e^x, Elogi=log1p(exp(x))
% x>=0, large e^x, Elogi=log(1+exp(x))
Elogi=(x<0).*log1p(exp(x))+(x>=0).*log(1+exp(x));

% Mean logistic error over all data points
Elog=mean(Elogi);

end