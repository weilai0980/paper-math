function [ out ] = sigmoid( A )

% This function gives sigmoid(.) for each element of A.
% The sigmoid function is defined as sigmoid(a)=1./(1+e^(-a))
% The output is of the same size as the input.

out=1./(1+exp(-A));

end


