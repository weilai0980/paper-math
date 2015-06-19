function [ grad ] = computeErrorGradient( x, t, parameter )
%Usage: Compute the activations and outputs of each layer
%Input: data x, label t and its parameter (weight and bias)
%Output: the gradient for each level

% Compute the activations and outputs of each layer
activation=computeActivationsForSingleInput(x,parameter);

% The residual
r2=-t*sigmoid(-t*activation.a2);
r1_nodivide2=r2.*(parameter.w2(1:1:end).*sigmoid(activation.a1(2:2:end)));
r1_divide2=r2.*(parameter.w2(1:1:end).*sigmoid(activation.a1(2:2:end)).*(1-sigmoid(activation.a1(2:2:end))));
size_r1=2*size(r1_nodivide2,1);
r1=0.5*kron(r1_nodivide2,ones(2,1)).*(ones(size_r1,1)-(-1).^(1:size_r1)')...
    +0.5*kron(r1_divide2,ones(2,1)).*(ones(size_r1,1)-(-1).^(0:size_r1-1)');

grad.b2=r2;
grad.w2=r2*gating(activation.a1(1:2:end),activation.a1(2:2:end));

grad.b1=r1;
grad.w1=r1*x;


end