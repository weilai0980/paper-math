function [ out ] = gating( A, B )
%Usage: Compute gating function
%Input: 2 values
%Output: the value of gating function

out = A.*sigmoid(B);

end