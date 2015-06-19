function [ out ] = gating( A, B )

out = A.*sigmoid(B);

end