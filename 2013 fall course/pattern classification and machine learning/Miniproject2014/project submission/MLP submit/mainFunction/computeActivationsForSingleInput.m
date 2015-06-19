function [ activation ] = computeActivationsForSingleInput( x, parameter )
%Usage: Compute activations for single input
%Input: data x and the parameter
%Output: its activation for each layers.

% First hidden layer activations
activation.a1=sum(parameter.w1*x',2)+parameter.b1;

% Second hidden layer activations
activation.a2=sum(parameter.w2.*gating(activation.a1(1:2:end),activation.a1(2:2:end)))+parameter.b2;

end